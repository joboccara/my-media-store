class RenameItemTypeToKind < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :type, :kind
  end
end
