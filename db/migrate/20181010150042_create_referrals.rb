class CreateReferrals < ActiveRecord::Migration[5.2]
  def change
    create_table :referrals do |t|
      t.string :referral_id

      t.timestamps
    end
  end
end
