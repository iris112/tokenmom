class TradeBroadcastJob < ApplicationJob
  queue_as :default

  def perform(trade)
    # Do something later
    ActionCable.server.broadcast 'trade_channel', trade: trade
  end
end
