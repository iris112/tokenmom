class OrderBroadcastJob < ApplicationJob
  queue_as :default

  def perform(type, order)
    # Do something later
    ActionCable.server.broadcast 'order_channel', order: order, type: type
  end
end
