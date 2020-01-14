class User < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  validates :nick_name, :wallet_address, presence: true
end
