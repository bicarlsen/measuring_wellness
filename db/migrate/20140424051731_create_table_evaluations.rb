class CreateTableEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
			t.belongs_to :recommendation
			t.belongs_to :consultation
			t.text :notes

			t.timestamps
    end
  end
end
