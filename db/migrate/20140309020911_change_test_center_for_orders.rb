class ChangeTestCenterForOrders < ActiveRecord::Migration
  def change
  	remove_column :orders, :test_center
		add_column :orders, :test_center_id, :integer
	end
end
