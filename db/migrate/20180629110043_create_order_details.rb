class CreateOrderDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :order_details do |t|
      t.text :signedorder

      t.timestamps
    end
  end
end
