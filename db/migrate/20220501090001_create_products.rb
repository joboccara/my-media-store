class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :kind
      t.string :title
      t.text :content
      t.string :isbn
      t.float :purchase_price
      t.boolean :is_hot
      t.integer :width
      t.integer :height
      t.string :source
      t.string :format
      t.integer :duration
      t.string :quality
      t.timestamps
    end
  end
end
