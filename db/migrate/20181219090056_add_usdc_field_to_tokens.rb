class AddUsdcFieldToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :usdc_field, :boolean
  end
end
