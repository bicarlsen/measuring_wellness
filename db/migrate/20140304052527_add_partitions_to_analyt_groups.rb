class AddPartitionsToAnalytGroups < ActiveRecord::Migration
	def change
  	remove_column :analyte_groups, :extreme_weight 
  	remove_column :analyte_groups, :severe_weight 
  	remove_column :analyte_groups, :moderate_weight 
  	remove_column :analyte_groups, :mild_weight 
  	remove_column :analyte_groups, :healthy_weight 
	
		add_column 		:analyte_groups, :partitions, :string
	end
end
