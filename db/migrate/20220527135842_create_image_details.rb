class CreateImageDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :image_details do |t|
      t.integer :width
      t.integer :height
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
