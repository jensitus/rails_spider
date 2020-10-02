class AddTheaterWithIdToSchedules < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :theater_id, :bigint
  end
end
