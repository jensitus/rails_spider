class TheaterController < ApplicationController

  before_action :set_theater, only: [:show, :the_movies]
  before_action :set_theater_schedules, only: [:theater_schedules, :and_the_movies]

  def list
    json_response(map_theater_collection(Theater.all))
  end

  def show
    # movies = theater.movies
    # theater_movies = TheaterMovies.new(map_theater(theater), map_movie_collection(movies))
    #  and_the_movies.each do |key, value|
    #    value.each do |mov_key, schedule_value|
    #      puts mov_key.inspect
    #      puts schedule_value.inspect
    #    end
    #  end

    json_response(@theater)
  end

  def theater_schedules
    json_response(@theater_schedules)
  end

  # def and_the_movies
  #   @and_the_movies = @theater_schedules.collect do |timeslot, schedule|
  #     [timeslot, Hash[schedule.group_by {|s| s.movie}]]
  #   end
  #   json_response(@and_the_movies)
  # end

  def the_movies
    puts @theater
    json_response(@theater.movies)
  end

  private

  def set_theater
    @theater = Theater.find(params[:id])
  end

  def set_theater_schedules
    @theater = Theater.find(params[:id])
    @theater_schedules = @theater.schedules
                             .group_by {|schedule| Time.at(schedule.time).strftime('%d.%m.')}
                             .collect {|timeslot, schedule| [timeslot, Hash[schedule.group_by {|s| s.movie.title}]]}
  end

  def old_code
    # @theaterSchedules = @theater.schedules
    # fsd = @theaterSchedules.group_by { |date| Time.at(date.unixtime).strftime('%d.%m.')}
    # @fetchScreeningDates = fsd.collect{|timeslot, schedule| [timeslot, Hash[schedule.group_by {|s| s.movie}]]}
  end

end
