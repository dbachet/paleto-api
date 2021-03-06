class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content, null: false
      t.integer :pallet_id
      t.integer :user_id

      t.timestamps null: false
    end
    add_foreign_key :comments, :users, on_delete: :cascade
    add_foreign_key :comments, :pallets, on_delete: :cascade
  end
end
