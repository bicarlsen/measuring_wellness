class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
			t.string 	:name
			t.string 	:email
			t.string 	:password_digest
			
			t.date		:birth_date
			t.float		:weight
			t.float		:height
			t.string	:gender

			t.boolean :admin
      
			t.timestamps
    end

		add_index :users, :email, unique: true
  end
end
