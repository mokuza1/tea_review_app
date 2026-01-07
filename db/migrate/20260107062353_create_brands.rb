class CreateBrands < ActiveRecord::Migration[8.1]
  def change
    create_table :brands do |t|
      t.references :user, null: false, foreign_key: true

      # 承認者（未承認を許容する）
      t.references :approved_by, null: true,
                   foreign_key: { to_table: :users }

      t.string :name_ja
      t.string :name_en
      t.string :country
      t.text :description
      t.integer :status, null: false, default: 0
      t.datetime :approved_at

      t.timestamps
    end
  end
end
