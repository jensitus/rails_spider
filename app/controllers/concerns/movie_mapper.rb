module MovieMapper

  def map_movie(movie)
    movieDto = MovieDto.new(movie.id, movie.title, movie.originaltitle, movie.shortdescription, movie.runtime, movie.genres)
  end

  def map_movie_collection(movies)
    moviesDto = []
    movies.each do |movie|
      moviesDto.push(map_movie(movie))
    end
    moviesDto
  end

end
