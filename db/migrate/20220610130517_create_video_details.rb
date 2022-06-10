class CreateVideoDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :video_details do |t|
      t.integer :duration
      t.string :quality

      t.timestamps
    end
  end
end
