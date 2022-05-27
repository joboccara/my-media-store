class CreateBookDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :book_details do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :page_count

      t.timestamps
    end
  end
end
