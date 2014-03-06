class ChangeDefaultWeightInGroups < ActiveRecord::Migration
	def change
		rename_column :analyte_groups, :default_severity_weights, :default_weights
		change_column :analyte_groups, :default_weights, :text
	end
end
