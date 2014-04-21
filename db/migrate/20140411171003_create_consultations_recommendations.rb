class CreateConsultationsRecommendations < ActiveRecord::Migration
  def change
		create_table :consutations_recommendations, id: false do |t|
			t.belongs_to :consultation
			t.belongs_to :recommendation
		end
  end
end
