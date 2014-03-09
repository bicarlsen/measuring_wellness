class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
			t.belongs_to :test
			t.belongs_to :analyte
			t.decimal :amount

      t.timestamps
    end

		add_index :results, :test_id
  end
end
