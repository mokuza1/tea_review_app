class CreateTeaProductSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :tea_product_submissions do |t|
      t.timestamps
    end
  end
end
