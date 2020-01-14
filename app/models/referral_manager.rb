class ReferralManager < ApplicationRecord
  validates :wallet_address, presence: true
end
