class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
			t.string :name
			t.boolean :active
			t.integer :priority
			t.string :severity
			t.text :summary
			t.text :description
			t.string :products
			t.text :triggers

      t.timestamps
    end
  end
end
