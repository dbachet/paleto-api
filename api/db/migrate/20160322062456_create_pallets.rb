class CreatePallets < ActiveRecord::Migration
  def change
    create_table :pallets do |t|
      t.string :title, :description, null: false
      t.decimal :longitude, :latitude, precision: 10, scale: 6, null: false
      t.integer :user_id

      t.timestamps null: false
    end
    add_foreign_key :pallets, :users, on_delete: :cascade
  end
end
