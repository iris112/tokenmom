class ChangeColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    
    remove_column :orders, :price, :float
    remove_column :orders, :amount, :float
    add_column :orders, :amount, :decimal, precision: 16, scale: 8
    add_column :orders, :price, :decimal, precision: 16, scale: 8
  end
end
