class AddTMfieldToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :tm_field, :boolean
    add_column :tokens, :weth_token, :boolean
  end
end
