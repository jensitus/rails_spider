class TheaterController < ApplicationController

  def list
    json_response(map_theater_collection(Theater.all))
  end

  def show
    theater = Theater.find(params[:id])
    movies = theater.movies
    theaterMovies = TheaterMovies.new(map_theater(theater), map_movie_collection(movies))
    json_response(theaterMovies)
  end

  def movies
    theater = Theater.find(params[:id])
    movies = theater.movies
    moviesDto = map_movie_collection(movies)
    json_response(moviesDto)
  end

end
