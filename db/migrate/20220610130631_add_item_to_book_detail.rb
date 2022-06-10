class AddItemToBookDetail < ActiveRecord::Migration[7.0]
  def change
    add_reference :book_details, :item, foreign_key: true
  end
end
