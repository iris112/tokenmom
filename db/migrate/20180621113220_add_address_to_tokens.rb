class AddAddressToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :address, :string
  end
end
