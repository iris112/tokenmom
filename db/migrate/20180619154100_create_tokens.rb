class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.string :name, null: false
      t.string :symbol, null: false
      t.timestamps
    end
  end
end
