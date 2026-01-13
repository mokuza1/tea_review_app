class CreateFlavors < ActiveRecord::Migration[8.1]
  def change
    create_table :flavors do |t|
      t.string :name, null: false
      t.references :flavor_category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :flavors, [:flavor_category_id, :name], unique: true
  end
end
