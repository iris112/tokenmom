class AddColumtoOrderDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :order_details, :expire, :integer
    add_column :order_details, :taker_amount, :decimal, :precision => 10, :scale => 8
    add_column :order_details, :maker_amount, :decimal, :precision => 10, :scale => 8
  end
end
