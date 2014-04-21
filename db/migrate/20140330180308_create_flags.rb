class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :name
      t.boolean :active
      t.integer :priority
      t.string :severity
      t.text :trigger

      t.timestamps
    end
  end
end
