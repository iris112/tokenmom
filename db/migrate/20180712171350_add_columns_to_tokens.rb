class AddColumnsToTokens < ActiveRecord::Migration[5.2]
  def change
    remove_column :tokens, :address, :string
    remove_column :trade_histories, :wallet_address, :string
    add_column :trade_histories, :maker_address, :string
    add_column :trade_histories, :taker_address, :string
    add_column :trade_histories, :txHash, :string
    add_column :orders, :maker_address, :string
    remove_column :order_details, :taker_amount, :decimal, :precision => 10, :scale => 8
    remove_column :order_details, :maker_amount, :decimal, :precision => 10, :scale => 8
    add_column :order_details, :taker_amount, :decimal, :precision => 21, :scale => 10
    add_column :order_details, :maker_amount, :decimal, :precision => 21, :scale => 10
    remove_column :orders, :amount, :decimal, precision: 16, scale: 8
    remove_column :orders, :price, :decimal, precision: 16, scale: 8
    add_column :orders, :amount, :decimal, precision: 21, scale: 10
    add_column :orders, :price, :decimal, precision: 21, scale: 10
    add_column :tokens, :token_decimals, :integer
  end
end
