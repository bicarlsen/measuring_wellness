class ModifyAnalyteRulesAssociation < ActiveRecord::Migration
  def change
  	remove_column :analytes, :rule_id
		add_column :rules, :analyte_id, :integer
	end
end
