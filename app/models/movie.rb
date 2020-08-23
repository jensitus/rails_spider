# encoding: utf-8
require 'open-uri'
class Movie < ApplicationRecord

    validates :_ID, presence: true
    validates :_ID, uniqueness: true

	HEADERS_HASH = { 'User-Agent' => 'lets crawl'}

    TMDB_HEADERS = {:accept => 'application/json'}
    TMDB_API_KEY = '933cdd7171c5106e4492577f3f008c5d'

	logger = Rails.logger

	def self.fetch_movies
		da = Date.today
    date = da.upto( da + 7  )
   	date.each do |d|
			response_zum_donner = RestClient::Request.new(
				:method => :get,
				:url => "https://efs.skip.at/api/v1/cfs/filmat/screenings/nested/movie/#{d}"
			).execute
			results = JSON.parse(response_zum_donner.to_str)
     	results["result"].each do |r|
     		if r["parent"]["type"] == "movie"
     			r["nestedResults"].each do |nr|
     				if nr["parent"]["county"] == "Wien"
     					title = r["parent"]["title"].downcase.gsub(/\s/, '-').gsub('ä', 'ae').gsub('ö', 'oe').gsub('ü', 'ue').gsub('ñ', 'n').gsub('ß', 'ss').gsub('---', '-').delete("?!'.")
     					detail_url = "https://www.skip.at/" + title
     					page = Nokogiri::HTML(open(detail_url, HEADERS_HASH))
     					propably_the_original = page.css('p[class="movieDetail-ovTitle"]').text
     					country_year = page.css('p[class="movieDetail-country"]').text
     					country_year.strip!
     					year = country_year[-4,4]
     					country = country_year.delete(year).strip
     					c = remove_trailing_comma(country)
     					# genres:
     					genres = []
     					r["parent"]["genres"].each do |g|
     						genres << g
     					end
     					genres = genres.join(', ')
     					_ID = 'm-' << title << '-' << year
     					@m = Movie.new(
     						title: r["parent"]["title"],
     						_ID: _ID,
     						land: c,
     						year: year,
     						typename: "movie",
     						originaltitle: propably_the_original,
     						genres: genres
     						)
     					puts @m.inspect
     					save_movie(@m)
     					sleep 1
              fetch_image_tmdb(@m)
     				end
     			end
     		end
		  end
    end
  end

  def self.remove_trailing_comma(str)
    return_str = str.nil? ? nil : str.chomp(",")
    return_str
  end

  def self.save_movie(m)
  	if m.save
        puts 'success'
    else
        puts 'oh no'
    end
  	sleep 2
  end

  def self.fetch_image_tmdb(movie)
    if movie.originaltitle.nil?
      searchTitle = movie.title
      searchTitleWithPlus = searchTitle.gsub(/\s/, '+')
      y = movie.year
    elsif movie.originaltitle == ''
      searchTitle = movie.title
      searchTitleWithPlus = searchTitle.gsub(/\s/, '+')
      y = movie.year
    else
      searchTitle = movie.originaltitle
      searchTitleWithPlus = searchTitle.gsub(/\s/, '+')
      y = movie.year
    end
    tmdb_movie_id = get_tmdb_movie_id(searchTitle, searchTitleWithPlus, y)
    puts tmdb_movie_id
    sleep 20
    mov_poster = get_poster_path(searchTitle, searchTitleWithPlus, y)
    if mov_poster.nil?
      # shut the fuck up
    elsif mov_poster.empty?
      # shut the fuck up
    else
      movie.update(imageurl: mov_poster)
    end
    mov_poster = nil
    shortdescription = get_shortdescription(searchTitle, searchTitleWithPlus, y)
    movie.update(:shortdescription => shortdescription)
    shortdescription = nil
  end

  def self.get_poster_path(searchTitle, searchTitleWithPlus, y)
    poster_path_url = nil
    tmdb_id = get_tmdb_movie_id(searchTitle, searchTitleWithPlus, y)
    tmdb_id.each do |movie_id|
      m = get_rest_access_tmdb(movie_id)
      year = m['release_date'].to_date.strftime('%Y')
      if m['poster_path'].nil?
        return nil
      else
        ppu = m['poster_path']
        poster_path_url = "https://image.tmdb.org/t/p/w185#{ppu}"
      end
    end
    return poster_path_url
  end

  def self.get_shortdescription(queue, qu, y)
    shortdescription = nil
    tmdb_movie_id = get_tmdb_movie_id(queue, qu, y)
    m = get_rest_access_tmdb(tmdb_movie_id)
    if m['overview'].nil?
      shortdescription = get_shortdescription_if_de_is_nil(queue, qu, y)
    else
      shortdescription = m['overview']
    end
    return shortdescription
  end

  def self.get_shortdescription_if_de_is_nil(queue, qu, y)
    tmdb_movie_id = get_tmdb_movie_id(queue, qu, y)
    tmdb_movie_id.each do |movie_id|
      movie = RestClient.get("https://api.themoviedb.org/3/movie/#{movie_id}?language=en&api_key=#{TMDB_API_KEY}", TMDB_HEADERS)
      m = ActiveSupport::JSON.decode(movie)
      shortdescription = m['overview']
      return shortdescription
    end
  end

  private

  def self.get_tmdb_movie_id(queue, qu, y)
    uri = Addressable::URI.parse qu
    uri = uri.normalize
    puts "http://api.themoviedb.org/3/search/movie?query=#{uri}&api_key=#{TMDB_API_KEY}"
    response = RestClient.get("http://api.themoviedb.org/3/search/movie?query=#{uri}&api_key=#{TMDB_API_KEY}", TMDB_HEADERS)
    json = ActiveSupport::JSON.decode(response)
    potential_id = nil
    json.each { |k, v|
      v.each { |va|
        original_title = va['original_title'].downcase
        if va['release_date'] == nil
          puts false
        elsif va['release_date'] == ''
          puts false
        else
          year = va['release_date'].to_date.strftime('%Y')
          year = year.to_i
        end
        queue = queue.downcase
        if original_title == queue && y == year
          # potential_id = potential_id << va['id']
          potential_id = va['id']
        elsif original_title == queue && year == y + 1
          potential_id = va['id']
        elsif original_title == queue && year == y - 1
          potential_id = va['id']
        else
          puts false
        end
      } if v.is_a?(Array)
    }
    potential_id
  end

  def self.get_rest_access_tmdb(movie_id)
    ActiveSupport::JSON.decode RestClient.get("https://api.themoviedb.org/3/movie/#{movie_id}?language=de&api_key=#{TMDB_API_KEY}", TMDB_HEADERS)
  end



end
