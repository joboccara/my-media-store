class CreateBookDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :book_details do |t|
      t.references :product, null: false, foreign_key: true
      t.string :isbn
      t.float :purchase_price
      t.boolean :is_hot

      t.timestamps
    end
  end
end
