class RewardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reward_channel"
  end

  def unsubscribed
  end

  def broadcast params
    ActionCable.server.broadcast 'reward_channel', reward:params['data']['reward']
  end
end
