class CreateJoinTableAdminsComments < ActiveRecord::Migration
  def change
    create_join_table :admins, :comments do |t|
      t.index [:admin_id, :comment_id]
      t.index [:comment_id, :admin_id]
    end
  end
end
