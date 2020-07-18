class AddGenresToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :genres, :string
    add_index :movies, :_ID, unique: true
  end
end
