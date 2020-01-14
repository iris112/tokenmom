class AddReferralIdToReferralManager < ActiveRecord::Migration[5.2]
  def change
    add_column :referral_managers, :referral_id, :string, null: false
  end
end
