class CreateTeaProductSubmissionFlavors < ActiveRecord::Migration[8.1]
  def change
    create_table :tea_product_submission_flavors do |t|
      t.references :tea_product_submission, 
                   null: false, 
                   foreign_key: true,
                   index: { name: "idx_tps_flavors_on_submission_id" } 
      t.references :flavor, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tea_product_submission_flavors, 
              [:tea_product_submission_id, :flavor_id], 
              unique: true, 
              name: "idx_tps_flavors_unique"
  end
end
