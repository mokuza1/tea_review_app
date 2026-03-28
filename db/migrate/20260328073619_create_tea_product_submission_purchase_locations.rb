class CreateTeaProductSubmissionPurchaseLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :tea_product_submission_purchase_locations do |t|
      t.references :tea_product_submission, 
                   null: false, 
                   foreign_key: true,
                   index: { name: 'idx_tps_purchase_locations_on_submission_id' }
                   
      t.references :purchase_location, 
                   null: false, 
                   foreign_key: true

      t.timestamps
    end

    add_index :tea_product_submission_purchase_locations, 
              [:tea_product_submission_id, :purchase_location_id], 
              unique: true, 
              name: 'idx_tpspl_on_submission_and_location'
  end
end
