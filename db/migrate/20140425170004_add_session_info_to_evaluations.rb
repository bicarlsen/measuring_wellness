class AddSessionInfoToEvaluations < ActiveRecord::Migration
  def change
  	add_column :evaluations, :triggers, :text
		add_column :evaluations, :severity, :float
	end
end
