class AddOrderHashToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :order_hash, :string
  end
end
