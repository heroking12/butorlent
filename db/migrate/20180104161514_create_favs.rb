class CreateFavs < ActiveRecord::Migration[5.1]
  def change
    create_table :favs do |t|
      t.string :isbn
      t.integer :user_id

      t.timestamps
    end
  end
end
