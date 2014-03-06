class AddDefaultSeverityWeightsToGroups < ActiveRecord::Migration
  def change
  	remove_column :analyte_groups, :default_partitions
		add_column :analyte_groups, :default_severity_weights, :string

		change_column :rules, :partitions, :text
	end
end
