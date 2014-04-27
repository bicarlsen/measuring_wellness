class AddArchivedToFlagsAndREcs < ActiveRecord::Migration
  def change
  	add_column :flags, :archived, :boolean
		add_column :recommendations, :archived, :boolean
	end
end
