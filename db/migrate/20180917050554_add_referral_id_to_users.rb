class AddReferralIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :referral_id, :string
    add_column :users, :recommended_id, :string
  end
end
