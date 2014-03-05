class AddPartitionToRules < ActiveRecord::Migration
  def change
  	remove_column :rules, :extreme_range
		remove_column :rules, :severe_range
		remove_column :rules, :moderate_range
		remove_column :rules, :mild_range
		remove_column :rules, :healthy_range

		add_column :rules, :partitions, :string
	end
end
