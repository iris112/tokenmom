class TradeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "trade_channel"
  end

  def unsubscribed
  end

  def broadcast params
    token = Token.where("symbol = ?", params['data']['trade']['token_symbol']).first
    if token 
      if params['data']['trade']['base_token'] == "WETH"
        token.last_price_weth = token.last_price("WETH")
        token.h_price_weth = token.h_price("WETH")
        token.h_volume_weth = token.h_volume("WETH")
      elsif params['data']['trade']['base_token'] == "TM"
        token.last_price_tm = token.last_price("TM")
        token.h_price_tm = token.h_price("TM")
        token.h_volume_tm = token.h_volume("TM")
      elsif params['data']['trade']['base_token'] == "USDC"
        token.last_price_usdc = token.last_price("USDC")
        token.h_price_usdc = token.h_price("USDC")
        token.h_volume_usdc = token.h_volume("USDC")
      elsif params['data']['trade']['base_token'] == "WBTC"
        token.last_price_wbtc = token.last_price("WBTC")
        token.h_price_wbtc = token.h_price("WBTC")
        token.h_volume_wbtc = token.h_volume("WBTC")
      end
      token.save
    end
    ActionCable.server.broadcast 'trade_channel', trade:params['data']['trade']
  end
end
