class MovieController < ApplicationController

  def single_movie
    json_response(@movie)
  end

  def all
    @movies = Movie.all
    json_response(@movies)
  end

  def old_code
    # fd = @movieSchedules.group_by{ |date| Time.at(date.unixtime).strftime('%d.%m') }
    # @fetchDate= fd.collect{|timeslot, scheds| [timeslot, Hash[scheds.group_by{|s| s.theater}]]}
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

end
