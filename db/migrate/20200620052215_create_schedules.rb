class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.string :_ID
      t.datetime :time
      t.string :theater_ID
      t.string :movie_ID
      t.string :typename
      t.boolean :dreid
      t.boolean :ov
      t.string :info

      t.timestamps
    end
  end
end
