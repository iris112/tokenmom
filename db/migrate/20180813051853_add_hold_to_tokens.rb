class AddHoldToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :on_hold, :boolean
  end
end
