class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :kind
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
