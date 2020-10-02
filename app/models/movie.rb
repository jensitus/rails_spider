# encoding: utf-8
require 'open-uri'

class Movie < ApplicationRecord

  validates :_ID, presence: true
  validates :_ID, uniqueness: true

  has_many :schedules
  has_many :theaters, through: :schedules

  HEADERS_HASH = {'User-Agent' => 'lets crawl'}

  TMDB_HEADERS = {:accept => 'application/json'}
  TMDB_API_KEY = '933cdd7171c5106e4492577f3f008c5d'

  logger = Rails.logger

  def self.fetch_movies
    da = Date.today
    # da = da + 5
    date = da.upto(da + 7)
    date.each do |d|
      url = "https://efs.skip.at/api/v1/cfs/filmat/screenings/nested/movie/#{d}"
      puts url
      response_zum_donner = RestClient::Request.new(
          :method => :get,
          :url => url
      ).execute
      results = JSON.parse(response_zum_donner.to_str)
      results["result"].each do |r|
        if r["parent"]["type"] == "movie"
          r["nestedResults"].each do |nr|
            if nr["parent"]["county"] == "Wien"
              title = r["parent"]["title"].downcase.gsub(/\s/, '-').gsub('ä', 'ae').gsub('ö', 'oe').gsub('ü', 'ue').gsub('ñ', 'n').gsub('–', '-').gsub('ß', 'ss').gsub('---', '-').delete("?!'.,:&/()#").delete('"').gsub('--', '-').gsub('é', 'e')
              detail_url = "https://www.skip.at/" + title
              detail_url = remove_trailing_hyphen(detail_url)
              puts detail_url
              begin
                page = Nokogiri::HTML(URI.open(detail_url, HEADERS_HASH))
                country_year = page.css('p[class="movieDetail-country"]').text
                country_year.strip!
                year = country_year[-4, 4]
                propably_the_original = page.css('p[class="movieDetail-ovTitle"]').text
                country = country_year.delete(year).strip
                c = remove_trailing_comma(country)
              rescue # NotFound => e
                # puts e
              end
              unless year.nil?
                _ID = 'm-' << title << '-' << year.to_s
              else
                _ID = 'm-' << title
              end
              @m = Movie.find_by(_ID: _ID)
              if @m.nil?
                # genres:
                genres = []
                unless r["parent"]["genres"].nil?
                  r["parent"]["genres"].each do |g|
                    genres << g
                  end
                end
                genres = genres.join(', ')
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
                the_search_title_and_the_tmdb_id
              elsif @m.tmdb_id.nil?
                the_search_title_and_the_tmdb_id
              else
                # do nothing special
              end
              sleep 0.5
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

  def self.get_search_title(movie)
    if movie.originaltitle.nil? || movie.originaltitle == ''
      movie.title.delete('#')
    else
      movie.originaltitle.delete('#')
    end
  end

  def self.get_search_title_with_plus(movie)
    if movie.originaltitle.nil? || movie.originaltitle == ''
      movie.title.gsub(/\s/, '+').gsub('–', '').delete('#')
    else
      movie.originaltitle.gsub(/\s/, '+').gsub('–', '').delete('#')
    end
  end

  def self.fetch_image_tmdb(searchTitle, searchTitleWithPlus, movie)
    y = movie.year
    tmdb_movie_id = get_tmdb_movie_id(searchTitle, searchTitleWithPlus, y)
    puts tmdb_movie_id
    sleep 2
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
    m = get_rest_access_tmdb(tmdb_id)
    year = m['release_date'].to_date.strftime('%Y')
    if m['poster_path'].nil?
      return nil
    else
      ppu = m['poster_path']
      poster_path_url = "https://image.tmdb.org/t/p/w185#{ppu}"
    end
    poster_path_url
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
    shortdescription
  end

  def self.get_shortdescription_if_de_is_nil(queue, qu, y)
    tmdb_movie_id = get_tmdb_movie_id(queue, qu, y)
    tmdb_movie_id.each do |movie_id|
      begin
        movie = RestClient.get("https://api.themoviedb.org/3/movie/#{movie_id}?language=en&api_key=#{TMDB_API_KEY}", TMDB_HEADERS)
      rescue => e
        puts 'rescue that shit'
        puts e
      end
      m = ActiveSupport::JSON.decode(movie)
      shortdescription = m['overview']
      return shortdescription
    end
  end

  private

  def self.remove_trailing_hyphen(str)
    return_str = str.nil? ? nil : str.chomp("-")
    return_str
  end

  def self.the_search_title_and_the_tmdb_id
    searchTitle = get_search_title(@m)
    searchTitleWithPlus = get_search_title_with_plus(@m)
    tmdb_id = get_tmdb_movie_id(searchTitle, searchTitleWithPlus, @m.year)
    @m.update(tmdb_id: tmdb_id)
    if @m.tmdb_id?
      fetch_image_tmdb(searchTitle, searchTitleWithPlus, @m)
    end
  end


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
        puts '......'
        puts y.inspect
        puts y.class
        puts year.inspect
        puts '......'
        y = y.to_i
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
    r = RestClient.get("https://api.themoviedb.org/3/movie/#{movie_id}?language=de&api_key=#{TMDB_API_KEY}", TMDB_HEADERS)
    puts r.inspect
    ActiveSupport::JSON.decode r
  end


end
