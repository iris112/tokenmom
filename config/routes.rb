Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  match '/' => 'exchange#index', :as => :root, via: [:get, :post]

  get '/exchange/:trade_pair/wallet', to: 'exchange#wallet'
  get '/exchange/:trade_pair/orders', to: 'exchange#overview'
  get '/exchange/get_market', to: 'exchange#get_market'
  post '/exchange/:trade_pair/get_my_open_orders', to: 'exchange#get_my_open_orders'
  post '/exchange/:trade_pair/get_messages', to: 'exchange#get_messages'
  post '/exchange/:trade_pair/get_owner_data', to: 'exchange#get_owner_data'
  post '/exchange/:trade_pair/delete_my_orders', to: 'exchange#delete_my_orders'
  post '/exchange/:trade_pair/delete_my_order', to: 'exchange#delete_my_order'
  post '/exchange/:trade_pair/get_tokens', to: 'exchange#get_tokens'
  post '/exchange/:trade_pair/get_token_info', to: 'exchange#get_token_info'
  get '/exchange/:trade_pair', to: 'exchange#trade'
  get '/reward', to: 'exchange#reward'
  get '/referral', to: 'exchange#referral'
  get '/account', to: 'exchange#account'
  get '/whitepaper/:lang', to: 'exchange#download_whitepaper'
  get '/terms', to: 'exchange#terms'
  get '/privacy', to: 'exchange#privacy'
  post '/send_mail', to: 'exchange#send_mail'


  resources :exchange do
    collection do
      match :wallet, via: [:get]
      match :overview, via: [:get]
      match :trade, via: [:get, :post]
      post :get_reward
      post :get_referral
      post :request_reward
      post :get_users
      post :get_sort_token_list
      get :get_reward
      get :get_referral
      post :get_eth_usd_price
      post :get_init_data
      post :get_messages
      post :create_order
      post :get_orders
      post :get_my_open_orders
      post :get_signed_order
      post :create_trade_history
      post :get_trade_history
      post :get_tx
      post :remove_tx
      post :delete_order
      post :get_matching_orders
      post :update_order
      post :delete_my_order
      post :find_token
      post :get_owner_data
      post :delete_my_orders
      post :get_token_info
      post :get_tokens

    end
  end

  post 'user_sessions/user_login'
  get 'user_sessions/get_user'
  get '/sitemap' => 'sitemap#index', defaults: {format:"xml"}
  get '/robots.:format' => 'pages#robots'

  mount API::Base, at: "/"
  mount ActionCable.server => '/cable'

  Trestle::Engine.routes.draw do
    Trestle.admins.each do |name, admin|
      instance_eval(&admin.routes)
    end
    root to: "trestle/dashboard#index"
  end
end
