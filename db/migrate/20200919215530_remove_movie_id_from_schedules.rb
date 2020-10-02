class RemoveMovieIdFromSchedules < ActiveRecord::Migration[6.0]
  def change
    remove_column :schedules, :movie_ID
    remove_column :schedules, :theater_ID
  end
end
