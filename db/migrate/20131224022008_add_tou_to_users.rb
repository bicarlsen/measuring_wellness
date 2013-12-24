class AddTouToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tou, :boolean
  end
end
