class AddUniqueIndexToBrandsNameJa < ActiveRecord::Migration[8.1]
  def change
    add_index :brands, :name_ja, unique: true
  end
end
