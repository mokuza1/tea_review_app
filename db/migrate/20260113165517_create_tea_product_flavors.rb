class CreateTeaProductFlavors < ActiveRecord::Migration[8.1]
  def change
    create_table :tea_product_flavors do |t|
      t.references :tea_product, null: false, foreign_key: true
      t.references :flavor, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tea_product_flavors,
              [:tea_product_id, :flavor_id],
              unique: true
  end
end
