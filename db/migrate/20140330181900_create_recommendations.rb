class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
			t.belongs_to :user
			t.belongs_to :test
			t.text :session
			t.text :notes

      t.timestamps
    end
  end
end
