class CreateFlavorCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :flavor_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
