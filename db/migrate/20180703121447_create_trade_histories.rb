class CreateTradeHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :trade_histories do |t|
      t.string :wallet_address
      t.integer :type
      t.float :price
      t.float :amount
      t.string :base_token
      t.timestamps
    end
  end
end
