class AddStatesToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :last_price_weth, :decimal, precision: 21, scale: 10
    add_column :tokens, :h_price_weth, :decimal, precision: 21, scale: 10
    add_column :tokens, :h_volume_weth, :decimal, precision: 21, scale: 10
    add_column :tokens, :last_price_tm, :decimal, precision: 21, scale: 10
    add_column :tokens, :h_price_tm, :decimal, precision: 21, scale: 10
    add_column :tokens, :h_volume_tm, :decimal, precision: 21, scale: 10
    add_column :tokens, :last_price_usdc, :decimal, precision: 21, scale: 10
    add_column :tokens, :h_price_usdc, :decimal, precision: 21, scale: 10
    add_column :tokens, :h_volume_usdc, :decimal, precision: 21, scale: 10
  end
end
