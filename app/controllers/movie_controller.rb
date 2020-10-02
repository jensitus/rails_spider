class MovieController < ApplicationController

  def show
    @movie = Movie.find(params[:id])
    json_response(@movie.theaters)
  end

  def all
    @movies = Movie.all
    json_response(@movies)
  end

end
