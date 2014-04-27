class DeleteTableConsultationRecommendations < ActiveRecord::Migration
  def change
  	drop_table :consultations_recommendations
	end
end
