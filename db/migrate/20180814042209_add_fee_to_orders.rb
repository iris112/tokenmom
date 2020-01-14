class AddFeeToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :fee, :decimal, precision: 21, scale: 10
  end
end
