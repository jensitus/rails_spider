class Schedule < ApplicationRecord
  validates :_ID, presence: true
  validates :_ID, uniqueness: true

  BASE_URL = "https://efs.skip.at/api/v1/cfs/filmat/screenings/flat/cinema/"

  HEADERS_HASH = {'User Agent' => 'Save The Date'}

  def self.get_schedules

    date = Date.today
    date = date.upto(date + 7)

    Theater.get_all().each do |t|
      puts t.name
      puts t.name.downcase.gsub(/\s/, '-')


      detail_url = BASE_URL + t.skip_id + "/"

      date.each do |d|
        puts d.inspect
        response_zum_donner = RestClient::Request.new(
            :method => :get,
            :url => detail_url + d.to_s
        ).execute
        results = JSON.parse(response_zum_donner.to_str)
        results["result"].each do |r|
          # puts r.inspect
          if r.empty?
            # do nothin
          else
            if r["parent"]["type"] == "movie"
              puts r["parent"]["title"]
              puts r["screenings"][0]["time"]
              time = r["screenings"][0]["time"].to_datetime
              puts time.inspect
              puts time.class
              # movie_title = r["parent"]["title"].downcase.gsub(/\s/, '-').gsub('ä', 'ae').gsub('ö', 'oe').gsub('ü', 'ue').gsub('ñ', 'n').gsub('ß', 'ss').gsub('---', '-').delete("?!'.")
              m = Movie.find_by(title: r["parent"]["title"])
              if m.nil?
                movie_title = r["parent"]["title"].split(' ')
                movie_title = movie_title[0] + ' ' + movie_title[1]
                m = Movie.find_by_sql ["select * from movies where title like ?", "%#{movie_title}%"]
                if m.size == 1
                  m = m[0]
                end
              end
              unless m.nil?
                puts 'm.inspect'
                puts m._ID
                puts t._ID
                _ID = "s-" + t._ID + m._ID + time.to_s
                @schedule = Schedule.new(
                    _ID: _ID,
                    time: time,
                    theater_ID: t._ID,
                    movie_ID: m._ID,
                    typename: "schedule"
                )
                if @schedule.save
                  puts "absolutely yes"
                else
                  puts "this is the real shit"
                end
              end
            end
          end
        end
        sleep 3
      end

    end
  end

end
