class AddPublishedToConsultations < ActiveRecord::Migration
  def change
 		add_column :consultations, :published, :boolean
 	end
end
