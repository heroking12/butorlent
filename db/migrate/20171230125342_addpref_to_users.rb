class AddprefToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pref, :string
  end
end
