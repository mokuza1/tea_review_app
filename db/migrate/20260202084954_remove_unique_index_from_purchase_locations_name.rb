class RemoveUniqueIndexFromPurchaseLocationsName < ActiveRecord::Migration[8.1]
  def change
    remove_index :purchase_locations, :name
    add_index    :purchase_locations, :name
  end
end
