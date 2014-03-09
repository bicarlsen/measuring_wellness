class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
			t.belongs_to :user
			t.belongs_to :order
			t.belongs_to :test_center

      t.timestamps
    end 
  end
end
