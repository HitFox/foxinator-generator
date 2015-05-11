class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :identifier
      t.string :name
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :roles, :identifier
  end
end
