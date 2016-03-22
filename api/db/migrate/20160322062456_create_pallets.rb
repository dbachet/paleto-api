class CreatePallets < ActiveRecord::Migration
  def change
    create_table :pallets do |t|
      t.string :title
      t.string :description
      t.decimal :longitude, precision: 10, scale: 6
      t.decimal :latitude, precision: 10, scale: 6

      t.timestamps null: false
    end
  end
end
