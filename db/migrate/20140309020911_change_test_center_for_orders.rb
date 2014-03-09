class ChangeTestCenterForOrders < ActiveRecord::Migration
  def change
  	rename_column :orders, :test_center, :test_center_id
		change_column :orders, :test_center_id, :integer
	end
end
