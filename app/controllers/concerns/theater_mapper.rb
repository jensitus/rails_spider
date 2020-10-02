module TheaterMapper

  def map_theater(theater)
    theaterDto = TheaterDto.new(theater.id, theater.name, theater.address, theater.url, theater.telephone)
  end

  def map_theater_collection(theaters)
    theatersDto = []
    theaters.each do |theater|
      theatersDto.push(map_theater(theater))
    end
    theatersDto
  end

end
