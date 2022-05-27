class CreateVideoDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :video_details do |t|
      t.integer :duration
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
