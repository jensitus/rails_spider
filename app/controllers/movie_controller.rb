class MovieController < ApplicationController

  def show
    @movie = Movie.find(params[:id])
    json_response(@movie.theaters)
  end

  def all
    @movies = Movie.all
    json_response(@movies)
  end

  def old_code
    # fd = @movieSchedules.group_by{ |date| Time.at(date.unixtime).strftime('%d.%m') }
    # @fetchDate= fd.collect{|timeslot, scheds| [timeslot, Hash[scheds.group_by{|s| s.theater}]]}
  end

end
