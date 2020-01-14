class CreatePendingTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :pending_trades do |t|
      t.integer :type
      t.string :base_token
      t.string :token_symbol
      t.decimal :amount, precision: 21, scale: 10
      t.decimal :price, precision: 21, scale: 10
      t.string :maker_address
      t.string :taker_address
      t.string :txHash
      t.boolean :reward_status

      t.timestamps
    end
  end
end
