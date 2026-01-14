class CreateTeaProductPurchaseLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :tea_product_purchase_locations do |t|
      t.references :tea_product, null: false, foreign_key: true
      t.references :purchase_location, null: false, foreign_key: true

      t.timestamps
    end

        add_index :tea_product_purchase_locations,
              [ :tea_product_id, :purchase_location_id ],
              unique: true,
              name: "index_tppl_on_product_and_location"
  end
end
