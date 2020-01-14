class CreateReferralManagers < ActiveRecord::Migration[5.2]
  def change
    create_table :referral_managers do |t|
      t.string :wallet_address, null: false
      t.decimal :amount, precision: 21, scale: 10
      t.boolean :approved
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
