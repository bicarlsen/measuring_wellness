class AddPartitionsToAnalytes < ActiveRecord::Migration
  def change
  	add_column :analytes, :partitions, :text
	end
end
