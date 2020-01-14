class AddTotalAmountToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :total_amount, :decimal, precision: 21, scale: 10
  end
end
