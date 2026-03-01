class AddRejectionReasonToTeaProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :tea_products, :rejection_reason, :text
  end
end
