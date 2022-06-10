class AddPriceToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :price, :float
  end
end
