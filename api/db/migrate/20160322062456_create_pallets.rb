class CreatePallets < ActiveRecord::Migration
  def change
    create_table :pallets do |t|
      t.string :title, :description, null: false
      t.decimal :longitude, :latitude, precision: 10, scale: 6, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
