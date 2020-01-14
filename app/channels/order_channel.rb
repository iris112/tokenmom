class OrderChannel < ApplicationCable::Channel
  def subscribed
    stream_from "order_channel"
  end

  def unsubscribed
  end

  def broadcast params
    ActionCable.server.broadcast 'order_channel', order:params['data']['order'], type:params['data']['type']
  end
end
