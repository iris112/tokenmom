class AddTxhashToReferralManager < ActiveRecord::Migration[5.2]
  def change
    add_column :referral_managers, :txHash, :string
  end
end
