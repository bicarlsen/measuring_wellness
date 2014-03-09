class RemoveTestCenterFromTests < ActiveRecord::Migration
  def change
  	remove_column :tests, :test_center_id
	end
end
