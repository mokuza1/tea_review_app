class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tea_product, null: false, foreign_key: true

      t.integer :overall_rating, null: false
      t.integer :aroma_rating, null: false
      t.integer :bitterness_rating, null: false
      t.integer :strength_rating, null: false
      t.integer :sweetness_rating, null: false

      t.boolean :recommended_straight, default: false
      t.boolean :recommended_milk, default: false
      t.boolean :recommended_iced, default: false

      t.text :comment

      t.timestamps
    end

    add_index :reviews, [ :user_id, :tea_product_id ], unique: true
  end
end
