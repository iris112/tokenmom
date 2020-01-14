class AddRewardFieldToTradeTable < ActiveRecord::Migration[5.2]
  def change
    add_column :trade_histories, :reward_status, :boolean
  end
end
