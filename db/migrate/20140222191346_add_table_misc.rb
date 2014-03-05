class AddTableMisc < ActiveRecord::Migration
  def change
  	create_table :settings do |t|
			t.string 	:type
			t.string 	:key
			t.text		:value
		end

		add_index :settings, :type
	end
end
