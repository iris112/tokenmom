class AddTakerTotalAmountToTradeHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :trade_histories, :taker_total_amount, :decimal, precision: 21, scale: 10
  end
end
