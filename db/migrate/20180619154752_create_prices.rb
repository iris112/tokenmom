class CreatePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :prices do |t|
      t.references  :token
      t.string      :based_token
      t.string      :price

      t.timestamps
    end
  end
end
