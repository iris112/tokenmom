class ChangefiledsToOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :maker, :string
    remove_column :orders, :maker_amount, :string
    remove_column :orders, :maker_fee, :string
    remove_column :orders, :maker_token_addr, :string
    remove_column :orders, :taker, :string
    remove_column :orders, :taker_amount, :string
    add_column :orders, :base_token, :string
    add_column :orders, :amount, :float
    add_column :orders, :price, :float
    add_column :orders, :expire, :integer
    add_column :orders, :detail_id, :integer

  end
end
