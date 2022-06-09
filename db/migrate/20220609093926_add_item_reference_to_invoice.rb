class AddItemReferenceToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_reference :invoices, :item, foreign_key: true
  end
end
