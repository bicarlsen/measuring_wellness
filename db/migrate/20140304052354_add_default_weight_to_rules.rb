class AddDefaultWeightToRules < ActiveRecord::Migration
  def change
 		add_column :rules, :default_weight, :integer
 	end
end
