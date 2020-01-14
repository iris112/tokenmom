class AddfiledsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :maker, :string
    add_column :orders, :maker_amount, :string
    add_column :orders, :maker_fee, :string
    add_column :orders, :maker_token_addr, :string
    add_column :orders, :taker, :string
    add_column :orders, :taker_amount, :string

  end
end
