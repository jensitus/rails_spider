class Schedule < ApplicationRecord
  validates :_ID, presence: true
  validates :_ID, uniqueness: true

  belongs_to :movie
  belongs_to :theater

  BASE_URL = "https://efs.skip.at/api/v1/cfs/filmat/screenings/flat/cinema/"

  HEADERS_HASH = {'User Agent' => 'Save The Date'}

  def self.get_schedules

    date = Date.today
    date = date.upto(date + 7)

    Theater.get_all().each do |t|
      puts '++++ this ++++ is ++++ the ++++ beginning ------'
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
              time = r["screenings"][0]["time"].to_datetime
              m = Movie.find_by(title: r["parent"]["title"])
              # puts m.inspect
              if m.nil?
                movie_title = r["parent"]["title"].split(' ')
                movie_title = movie_title[0] + ' ' + movie_title[1]
                m = Movie.find_by_sql ["select * from movies where title like ?", "%#{movie_title}%"]
                if m.size == 1
                  m = m[0]
                end
              end
              sleep 0.1
              if m.class == Movie
                unless m.nil?
                  _ID = "s-" + t._ID + m._ID + time.to_s
                  @schedule = Schedule.new(
                      _ID: _ID,
                      time: time,
                      theater_id: t.id,
                      movie_id: m.id,
                      typename: "schedule"
                  )
                  puts @schedule.inspect
                  if @schedule.save
                    puts "absolutely yes"
                  else
                    puts "this is the real shit"
                  end
                end
              end
            end
          end
        end
        sleep 0.1
      end

    end
  end

  def get_schedule_for_theater_and_movie(theater_id, movie_id)
    where(theater_id: theater_id, movie_id: movie_id)
  end

  def self.delete_schedules
    t = Time.now
    Schedule.where(["time < ?", t]).each do |s|
      s.destroy
    end
  end

end
