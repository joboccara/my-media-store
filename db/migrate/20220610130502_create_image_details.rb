class CreateImageDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :image_details do |t|
      t.integer :width
      t.integer :height
      t.string :source
      t.string :format

      t.timestamps
    end
  end
end
