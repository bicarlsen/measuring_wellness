class AddRemovedToEvaluations < ActiveRecord::Migration
	def change
  	add_column :evaluations, :removed, :boolean, default: false
	end
end
