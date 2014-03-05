class RemoveWeightFromRules < ActiveRecord::Migration
  def change
  	remove_column :rules, :weight
	end
end
