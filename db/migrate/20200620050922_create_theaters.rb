class CreateTheaters < ActiveRecord::Migration[6.0]
  def change
    create_table :theaters do |t|
      t.string :_ID
      t.string :name
      t.string :typename
      t.string :address
      t.string :telephone
      t.string :url

      t.timestamps
    end
  end
end
