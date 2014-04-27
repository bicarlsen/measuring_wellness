class RemoveRowIdFromConsultationsRecommendations < ActiveRecord::Migration
	def change
  	rename_table :consutations_recommendations, :consultations_recommendations
		#remove_column :consultations_recommendations, :rowid
	end
end
