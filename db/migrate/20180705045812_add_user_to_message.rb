class AddUserToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :user_id, :integer, after: :room_id
  end
end
