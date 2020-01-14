class AddAmountToPrices < ActiveRecord::Migration[5.2]
  def change
    add_column :prices, :amount, :float
  end
end
