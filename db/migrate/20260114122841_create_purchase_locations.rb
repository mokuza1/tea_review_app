class CreatePurchaseLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :purchase_locations do |t|
      t.string  :name, null: false
      t.integer :location_type, null: false

      t.timestamps
    end

    add_index :purchase_locations, :name, unique: true
    add_index :purchase_locations, :location_type
  end
end
