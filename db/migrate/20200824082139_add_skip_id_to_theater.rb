class AddSkipIdToTheater < ActiveRecord::Migration[6.0]
  def change
    add_column :theaters, :skip_id, :string
  end
end
