class CreateBrands < ActiveRecord::Migration[8.1]
  def change
    create_table :brands do |t|
      t.references :user, null: false, foreign_key: true
      t.references :approved_by, null: false, foreign_key: true
      t.string :name_ja
      t.string :name_en
      t.string :country
      t.text :description
      t.integer :status
      t.datetime :approved_at

      t.timestamps
    end
  end
end
