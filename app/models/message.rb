class Message < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  validates :room_id, presence: true
  after_create_commit :broadcast_message

  private

  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end
end
