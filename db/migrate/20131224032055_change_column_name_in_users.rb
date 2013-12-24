class ChangeColumnNameInUsers < ActiveRecord::Migration
  def change
  	rename_column :users, :tou, :terms_of_use
	end
end
