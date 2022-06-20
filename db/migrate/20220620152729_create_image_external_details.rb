class CreateImageExternalDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :image_external_details do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :external_id

      t.timestamps
    end
  end
end
