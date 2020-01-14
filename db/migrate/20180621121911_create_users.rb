class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :wallet_address, null: false
      t.string :nick_name, default: 'Account'
      t.boolean :banned

      t.timestamps
    end
  end
end
