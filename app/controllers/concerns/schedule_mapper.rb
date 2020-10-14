module ScheduleMapper
  def map_schedule_to_dto(schedule)
    schedule_dto = ScheduleDto.new(schedule.time.strftime("%d.%m.%Y"), schedule.time.strftime("%H:%M"), schedule.movie_id, schedule.theater_id)
  end
end