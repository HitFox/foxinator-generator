class AddRoleIdToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :role_id, :integer
  end
end
