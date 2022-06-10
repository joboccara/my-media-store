class CreateBookDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :book_details do |t|
      t.string :isbn
      t.boolean :is_hot
      t.float :purchase_price

      t.timestamps
    end
  end
end
