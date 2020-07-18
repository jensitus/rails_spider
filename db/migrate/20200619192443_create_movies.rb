class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :_ID
      t.integer :runtime
      t.string :land
      t.integer :year
      t.string :originaltitle
      t.string :typename
      t.text :shortdescription
      t.string :imageurl
      t.boolean :upcoming
      t.integer :tmdb_id

      t.timestamps
    end
  end
end
