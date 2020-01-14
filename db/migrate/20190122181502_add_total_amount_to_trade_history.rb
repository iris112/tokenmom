class AddTotalAmountToTradeHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :trade_histories, :total_amount, :decimal, precision: 21, scale: 10
  end
end
