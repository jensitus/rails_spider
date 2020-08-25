class AddCompleteToMovie < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :complete, :boolean
  end
end
