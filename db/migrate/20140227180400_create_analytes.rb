class CreateAnalytes < ActiveRecord::Migration
  def change
    create_table :analytes do |t|
      t.string :name

      t.timestamps
    end
  end
end
