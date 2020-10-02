class AddMovieWithIdToSchedules < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :movie_id, :bigint
  end
end
