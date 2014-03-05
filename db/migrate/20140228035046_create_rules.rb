class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.integer :weight
      t.text :extreme_range
      t.text :severe_range
      t.text :moderate_range
      t.text :mild_range
      t.text :healthy_range
			t.belongs_to :analyte_group

      t.timestamps
    end

		add_index :rules, :analyte_group_id
  end
end
