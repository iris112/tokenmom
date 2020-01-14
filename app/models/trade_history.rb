class TradeHistory < ApplicationRecord
    self.inheritance_column = nil
    after_create_commit :broadcast_trade

    def broadcast_trade
        TradeBroadcastJob.perform_later(self)
    end
end
