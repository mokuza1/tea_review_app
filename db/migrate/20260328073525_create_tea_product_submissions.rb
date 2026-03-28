class CreateTeaProductSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :tea_product_submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tea_product, foreign_key: true, null: true
      t.references :brand, foreign_key: true, null: true

      t.references :previous_submission, foreign_key: { to_table: :tea_product_submissions }, null: true

      t.integer :status, default: 0, null: false

      t.string :name
      t.text :description
      t.integer :tea_type
      t.integer :caffeine_level

      t.references :approved_by, foreign_key: { to_table: :users }
      t.datetime :approved_at
      t.text :rejection_reason

      t.timestamps
    end

    add_index :tea_product_submissions, :status
  end
end
