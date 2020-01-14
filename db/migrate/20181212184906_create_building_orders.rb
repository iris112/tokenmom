class CreateBuildingOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :building_orders do |t|
      t.string :wallet_addr, null: false
      t.string :order_hash, null: false
      t.text :order
      t.text :param

      t.timestamps
    end
  end
end
