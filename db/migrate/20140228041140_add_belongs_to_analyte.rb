class AddBelongsToAnalyte < ActiveRecord::Migration
  def change
  	add_column :analytes, :rule_id, :integer
	end
end
