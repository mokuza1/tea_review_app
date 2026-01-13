class CreateFlavorCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :flavor_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :flavor_categories, :name, unique: true
  end
end
