class AddPromotionCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :promotion_code, :string
  	
		add_index :orders, :promotion_code
	end
end
