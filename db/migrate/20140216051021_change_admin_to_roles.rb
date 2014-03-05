class ChangeAdminToRoles < ActiveRecord::Migration
  def change
		rename_column :users, :admin, :roles
  end
end
