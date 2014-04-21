class ChangeActionsToRecommendations < ActiveRecord::Migration
	def change
  	rename_table :recommendations, :consultations
		rename_table :actions, :recommendations
	end
end
