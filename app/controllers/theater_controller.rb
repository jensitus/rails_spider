class TheaterController < ApplicationController

  def list
    json_response(Theater.all)
  end

  def show
    theater = Theater.find(params[:id])
    json_response(theater)
  end

  def movies
    theater = Theater.find(params[:id])
    json_response(theater.movies)
  end



end
