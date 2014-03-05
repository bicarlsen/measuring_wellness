class RemoveExtremeWieghtFromAnalyteCategories < ActiveRecord::Migration
  def change
  	remove_column :analyte_groups, :extreme_weight
	end
end
