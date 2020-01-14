class AddWbtcStatesToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :last_price_wbtc, :decimal, precision: 21, scale: 10
    add_column :tokens, :h_price_wbtc, :decimal, precision: 21, scale: 10
    add_column :tokens, :h_volume_wbtc, :decimal, precision: 21, scale: 10
  end
end
