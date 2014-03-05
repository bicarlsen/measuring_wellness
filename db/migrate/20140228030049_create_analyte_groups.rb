class CreateAnalyteGroups < ActiveRecord::Migration
  def change
    create_table :analyte_groups do |t|
      t.string 	:name
      t.integer :extreme_weight
      t.integer :severe_weight
      t.integer :moderate_weight
      t.integer :mild_weight
      t.integer :healthy_weight

      t.timestamps
    end
  end
end
