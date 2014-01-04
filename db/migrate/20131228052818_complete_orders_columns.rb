class CompleteOrdersColumns < ActiveRecord::Migration
  def change
  	add_column :orders, :user_id, :integer
		add_column :orders, :status, :string
		add_column :orders, :test_center, :string

		add_index :orders, :user_id
	end
end
