class AddfieldtoOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :token_symbol, :string
    change_column :orders, :price, :float, precision: 16, scale: 8
    change_column :orders, :amount, :float,precision: 16, scale: 8
  end
end
