class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :admin, index: true, foreign_key: true
      t.references :commentable, polymorphic: true, index: true
      t.string :message
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
