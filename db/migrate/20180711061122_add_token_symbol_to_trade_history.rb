class AddTokenSymbolToTradeHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :trade_histories, :token_symbol, :string
    remove_column :trade_histories, :amount, :float
    remove_column :trade_histories, :price, :float
    add_column :trade_histories, :amount, :decimal, precision: 21, scale: 10
    add_column :trade_histories, :price, :decimal, precision: 21, scale: 10
  end
end
