class CreateRewardManagers < ActiveRecord::Migration[5.2]
  def change
    create_table :reward_managers do |t|
      t.string :wallet_address, null: false
      t.decimal :amount, precision: 21, scale: 10
      t.boolean :approved
      t.boolean :status, default: false
      t.string :txHash

      t.timestamps
    end
  end
end
