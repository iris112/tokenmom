class AddWbtcFieldToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :wbtc_field, :boolean
  end
end
