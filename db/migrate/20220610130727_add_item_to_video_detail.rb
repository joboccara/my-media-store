class AddItemToVideoDetail < ActiveRecord::Migration[7.0]
  def change
    add_reference :video_details, :item, foreign_key: true
  end
end
