class AddItemToImageDetail < ActiveRecord::Migration[7.0]
  def change
    add_reference :image_details, :item, foreign_key: true
  end
end
