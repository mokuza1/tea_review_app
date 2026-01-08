class CreateTeaProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :tea_products do |t|
      t.references :user, null: false, foreign_key: true
      t.references :approved_by, null: true, foreign_key: { to_table: :users }
      t.references :brand, null: true, foreign_key: true
      t.string :name
      t.integer :tea_type
      t.integer :caffeine_level
      t.text :description
      t.integer :status, null: false, default: 0
      t.datetime :approved_at

      t.timestamps
    end
  end
end
