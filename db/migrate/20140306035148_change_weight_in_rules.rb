class ChangeWeightInRules < ActiveRecord::Migration
  def change
  	rename_column :rules, :default_weight, :weight
	end
end
