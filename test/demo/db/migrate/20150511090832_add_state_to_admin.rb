class AddStateToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :state, :string
    add_index :admins, :state
  end
end
