class ChangePartitionsInAnalyteGroup < ActiveRecord::Migration
  def change
  	rename_column :analyte_groups, :partitions, :default_partitions
	end
end
