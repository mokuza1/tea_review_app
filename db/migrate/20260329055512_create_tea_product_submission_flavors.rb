class CreateTeaProductSubmissionFlavors < ActiveRecord::Migration[8.1]
  def change
    create_table :tea_product_submission_flavors do |t|
      t.timestamps
    end
  end
end
