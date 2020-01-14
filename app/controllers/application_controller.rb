class ApplicationController < ActionController::Base
  def get_token_list
    tokens = Token.where("symbol != ?","WETH").order(created_at: :desc)  
    return tokens
  end
  def get_tokens_list_wallet
    tokens = Token.where("symbol != ?","WETH").order(symbol: :asc)  
    return tokens
  end

  def current_user
    return @current_user
  end

  def set_current_user user
    @current_user = user
  end

  def get_sellorder
    Order.order(created_at: :asc)
  end
end
