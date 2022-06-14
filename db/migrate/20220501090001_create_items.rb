class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :kind
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
