class AddToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :contract_address, :string, after: :symbol
  end
end
