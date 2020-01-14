class RewardManager < ApplicationRecord
  validates :wallet_address, presence: true
end
