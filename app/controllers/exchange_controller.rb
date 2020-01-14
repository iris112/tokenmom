require 'net/http'
require 'net/https'
require 'digest/md5'
require 'digest/sha1'
require 'uri'
require 'json'
require 'bigdecimal'
require "web3/eth/version"
require "web3/eth/abi/abi_coder"
require "web3/eth/utility"
require "web3/eth/block"
require "web3/eth/transaction"
require "web3/eth/contract"
require "web3/eth/call_trace"
require "web3/eth/log"
require "web3/eth/transaction_receipt"
require "web3/eth/eth_module"
require "web3/eth/trace_module"
require "web3/eth/etherscan"
require "web3/eth/rpc"
require "ethereum.rb"

$reward_ratio = 70
$web3 = Web3::Eth::Rpc.new host: 'ropsten.infura.io',
  port: 443,
  connect_options: {
    open_timeout: 20,
    read_timeout: 140,
    use_ssl: true,
    rpc_path: '/faf0e136035347acb2da6734879befac'
  }
$hash_function_name = {
  "withdraw" => "0x2e1a7d4d",
  "fillOrder" => "0xbc61394a",
  "batchFillOrKillOrders" => "0x4f150787",
  "approve" => "0x095ea7b3",
  "transfer" => "0xa9059cbb",
}
# Contract Addresses for ropsten network
$exchange_contract_addr = "0x479cc461fecd078f766ecc58533d6f69580cf3ac"
$token_contract_addr = "0x4e9aad8184de8833365fea970cd9149372fdf1e6"
$weth_contract_addr = "0xc778417e063141139fce010982780140aa0cd5ab"
$zrx_contract_addr = "0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d"
$tm_token_addr = "0x91495D6969120fc016BB687EaD5F5cE56F135504"
$tm_token_decimals = 18;

# Contract Addresses for kovan Network
# $exchange_contract_addr = "0x90fe2af704b34e0224bf2299c838e04d4dcf1364"
# $token_contract_addr = "0x087eed4bc1ee3de49befbd66c662b434b15d49d4"
# $weth_contract_addr = "0xd0a1e359811322d97991e03f863a0c30c2cf029c"
# $zrx_contract_addr = "0x6ff6c0ff1d68b964901f986d4c9fa3ac68346570"

# main net
# $exchange_contract_addr = "0x12459c951127e0c374ff9105dda097662a027093"
# $token_contract_addr = "0x8da0d80f5007ef1e431dd2127178d224e32c2ef4"
# $weth_contract_addr = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
# $zrx_contract_addr = "0xe41d2489571d322189246dafa5ebde1f4699f498"
# $tm_token_addr = "0xdac3a0c0aebeeb13b6eeab7cf9fe951664c9fd7c"
# $tm_token_decimals = 18;

# Set allowance value
$set_allow_value = "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
# Server Setting values

# Mainnet Server Wallet
# $wallet_address = "0x9c8372f5ee2c2e22826a316ea5b5ff8878adc582"
# $server_key = "AD102921DD933E1EF28B721CDA6A08B1427D935A5DC5DF7E0D07D6411B179BF7"

# Ropsten Server wallet
$wallet_address = "0x7Cc2768c52DEAB5Bc304485c0Fd82Bed287372cD"
$server_key = "6EFDB4FB96870179BC6DB81900B40B2DCA3F1E899A4FA180DA7A66A85C1EDD72"


$tm_wallet = "0x4cf8b831d3a1828fa3706d4124ee17ae224f9ddc"
$tm_wallet_key = "A1A65EAA0A6EE4A9F666A2DE54792BCAF9449196DB9D5C8045ED2ABFABA987D2"
$lastTxHash = nil
$lastTxHashDate = nil
$api = Web3::Eth::Etherscan.new api_key: "e39ce0f3cd8c44ca947f1f121b7b1ed5"
$exchange_abi =
  '[
    {"constant":true,
      "inputs":[
        {"name":"numerator","type":"uint256"},
        {"name":"denominator","type":"uint256"},
        {"name":"target","type":"uint256"}],
      "name":"isRoundingError",
      "outputs":[
        {"name":"","type":"bool"}],
      "payable":false,
      "type":"function"},
    {"constant":true,
      "inputs":[
        {"name":"","type":"bytes32"}],
      "name":"filled",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[{"name":"","type":"bytes32"}],
      "name":"cancelled",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5][]"},
        {"name":"orderValues","type":"uint256[6][]"},
        {"name":"fillTakerTokenAmount","type":"uint256"},
        {"name":"shouldThrowOnInsufficientBalanceOrAllowance","type":"bool"},
        {"name":"v","type":"uint8[]"},
        {"name":"r","type":"bytes32[]"},
        {"name":"s","type":"bytes32[]"}],
      "name":"fillOrdersUpTo",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5]"},
        {"name":"orderValues","type":"uint256[6]"},
        {"name":"cancelTakerTokenAmount","type":"uint256"}],
      "name":"cancelOrder",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[],
      "name":"ZRX_TOKEN_CONTRACT",
      "outputs":[{"name":"","type":"address"}],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5][]"},
        {"name":"orderValues","type":"uint256[6][]"},
        {"name":"fillTakerTokenAmounts","type":"uint256[]"},
        {"name":"v","type":"uint8[]"},
        {"name":"r","type":"bytes32[]"},
        {"name":"s","type":"bytes32[]"}],
      "name":"batchFillOrKillOrders",
      "outputs":[],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5]"},
        {"name":"orderValues","type":"uint256[6]"},
        {"name":"fillTakerTokenAmount","type":"uint256"},
        {"name":"v","type":"uint8"},
        {"name":"r","type":"bytes32"},
        {"name":"s","type":"bytes32"}],
      "name":"fillOrKillOrder",
      "outputs":[],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[{"name":"orderHash","type":"bytes32"}],
      "name":"getUnavailableTakerTokenAmount",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[
        {"name":"signer","type":"address"},
        {"name":"hash","type":"bytes32"},
        {"name":"v","type":"uint8"},
        {"name":"r","type":"bytes32"},
        {"name":"s","type":"bytes32"}],
      "name":"isValidSignature",
      "outputs":[{"name":"","type":"bool"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[
        {"name":"numerator","type":"uint256"},
        {"name":"denominator","type":"uint256"},
        {"name":"target","type":"uint256"}],
      "name":"getPartialAmount",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[],
      "name":"TOKEN_TRANSFER_PROXY_CONTRACT",
      "outputs":[{"name":"","type":"address"}],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5][]"},
        {"name":"orderValues","type":"uint256[6][]"},
        {"name":"fillTakerTokenAmounts","type":"uint256[]"},
        {"name":"shouldThrowOnInsufficientBalanceOrAllowance","type":"bool"},
        {"name":"v","type":"uint8[]"},
        {"name":"r","type":"bytes32[]"},
        {"name":"s","type":"bytes32[]"}],
      "name":"batchFillOrders",
      "outputs":[],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5][]"},
        {"name":"orderValues","type":"uint256[6][]"},
        {"name":"cancelTakerTokenAmounts","type":"uint256[]"}],
      "name":"batchCancelOrders","outputs":[],
      "payable":false,"type":"function"},
    {"constant":false,
      "inputs":[
        {"name":"orderAddresses","type":"address[5]"},
        {"name":"orderValues","type":"uint256[6]"},
        {"name":"fillTakerTokenAmount","type":"uint256"},
        {"name":"shouldThrowOnInsufficientBalanceOrAllowance","type":"bool"},
        {"name":"v","type":"uint8"},
        {"name":"r","type":"bytes32"},
        {"name":"s","type":"bytes32"}],
      "name":"fillOrder",
      "outputs":[{"name":"filledTakerTokenAmount","type":"uint256"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[
        {"name":"orderAddresses","type":"address[5]"},
        {"name":"orderValues","type":"uint256[6]"}],
      "name":"getOrderHash",
      "outputs":[{"name":"","type":"bytes32"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[],
      "name":"EXTERNAL_QUERY_GAS_LIMIT",
      "outputs":[{"name":"","type":"uint16"}],
      "payable":false,"type":"function"},
    {"constant":true,
      "inputs":[],
      "name":"VERSION",
      "outputs":[{"name":"","type":"string"}],
      "payable":false,"type":"function"},
    {
      "inputs":[
        {"name":"_zrxToken","type":"address"},
        {"name":"_tokenTransferProxy","type":"address"}],
      "payable":false,"type":"constructor"},
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"maker","type":"address"},
        {"indexed":false,"name":"taker","type":"address"},
        {"indexed":true,"name":"feeRecipient","type":"address"},
        {"indexed":false,"name":"makerToken","type":"address"},
        {"indexed":false,"name":"takerToken","type":"address"},
        {"indexed":false,"name":"filledMakerTokenAmount","type":"uint256"},
        {"indexed":false,"name":"filledTakerTokenAmount","type":"uint256"},
        {"indexed":false,"name":"paidMakerFee","type":"uint256"},
        {"indexed":false,"name":"paidTakerFee","type":"uint256"},
        {"indexed":true,"name":"tokens","type":"bytes32"},
        {"indexed":false,"name":"orderHash","type":"bytes32"}],
      "name":"LogFill","type":"event"},
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"maker","type":"address"},
        {"indexed":true,"name":"feeRecipient","type":"address"},
        {"indexed":false,"name":"makerToken","type":"address"},
        {"indexed":false,"name":"takerToken","type":"address"},
        {"indexed":false,"name":"cancelledMakerTokenAmount","type":"uint256"},
        {"indexed":false,"name":"cancelledTakerTokenAmount","type":"uint256"},
        {"indexed":true,"name":"tokens","type":"bytes32"},
        {"indexed":false,"name":"orderHash","type":"bytes32"}],
      "name":"LogCancel","type":"event"},
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"errorId","type":"uint8"},
        {"indexed":true,"name":"orderHash","type":"bytes32"}],
      "name":"LogError","type":"event"}]'
$token_abi =
  '[
    {"constant":true,
      "inputs":[],
      "name":"name",
      "outputs":[
        {"name":"","type":"string"}
      ],
      "payable":false,
      "type":"function"
    },
    {"constant":false,
      "inputs":[
        {"name":"_spender","type":"address"},
        {"name":"_value","type":"uint256"}
      ],
      "name":"approve",
      "outputs":[{"name":"","type":"bool"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[],
      "name":"totalSupply",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"
    },
    {"constant":false,
      "inputs":[
        {"name":"_from","type":"address"},
        {"name":"_to","type":"address"},
        {"name":"_value","type":"uint256"}
      ],
      "name":"transferFrom",
      "outputs":[{"name":"","type":"bool"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[],
      "name":"decimals",
      "outputs":[{"name":"","type":"uint8"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[{"name":"_owner","type":"address"}],
      "name":"balanceOf",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[],
      "name":"symbol",
      "outputs":[{"name":"","type":"string"}],
      "payable":false,"type":"function"
    },
    {"constant":false,
      "inputs":[
        {"name":"_to","type":"address"},
        {"name":"_value","type":"uint256"}
      ],
      "name":"transfer",
      "outputs":[{"name":"","type":"bool"}],
      "payable":false,"type":"function"
    },
    {"constant":true,
      "inputs":[
        {"name":"_owner","type":"address"},
        {"name":"_spender","type":"address"}
      ],
      "name":"allowance",
      "outputs":[{"name":"","type":"uint256"}],
      "payable":false,"type":"function"
    },
    {
      "inputs":[],
      "payable":false,"type":"constructor"
    },
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"_from","type":"address"},
        {"indexed":true,"name":"_to","type":"address"},
        {"indexed":false,"name":"_value","type":"uint256"}
      ],
      "name":"Transfer","type":"event"
    },
    {
      "anonymous":false,
      "inputs":[
        {"indexed":true,"name":"_owner","type":"address"},
        {"indexed":true,"name":"_spender","type":"address"},
        {"indexed":false,"name":"_value","type":"uint256"}
      ],
      "name":"Approval","type":"event"
    }
  ]'
$refer_id
$reward_request_amount = 3000
# $reward_request_amount = 100
$reward_tm_fee = 100
class ExchangeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    h = mk_referral_id($wallet_address)
    @eth_price = get_eth_price
    $refer_id = params[:r]
  end
  def wallet
    base_token = params[:trade_pair].split("-")[1]
    token_symbol = params[:trade_pair].split("-")[0]
    @refer_id = $refer_id
    @base_token = base_token

    # ETH token table
    @tokenlist = get_token_list

    @tokens_list = get_tokens_list_wallet

    @notifications = Notification.order(created_at: :asc)

    token = Token.where("symbol = ?",token_symbol).first
    if token
      @zrxtoken = token
    else
      @zrxtoken = Token.where("symbol = ?","ZRX").first
    end
    # Convert token contract address to
    @changed_contract = change_contract_address(@zrxtoken.contract_address)
    @user_id = current_user ? current_user.id : nil
  end
  def overview
    base_token = params[:trade_pair].split("-")[1]
    token_symbol = params[:trade_pair].split("-")[0]
    @refer_id = $refer_id
    @base_token = base_token

    # # ETH token table
    @tokenlist = get_token_list

    @notifications = Notification.order(created_at: :asc)

    token = Token.where("symbol = ?",token_symbol).first
    if token
      @zrxtoken = token
    else
      @zrxtoken = Token.where("symbol = ?","ZRX").first
    end
    # Convert token contract address to
    @changed_contract = change_contract_address(@zrxtoken.contract_address)
    @user_id = current_user ? current_user.id : nil
  end
  def trade
    base_token = params[:trade_pair].split("-")[1]
    token_symbol = params[:trade_pair].split("-")[0]
    @refer_id = $refer_id
    @base_token = base_token
    @eth_price = get_eth_price
    # Get messages
    @messages = Message.order(updated_at: :asc)
    # ETH token table
    @tokenlist = get_token_list

    @tokens_list = get_tokens_list_wallet
    # TM token table
    @tmtokenlist = Token.where("tm_field = ?", 1).order(symbol: :asc)

    @notifications = Notification.order(created_at: :asc)

    token = Token.where("symbol = ?",token_symbol).first
    if token
      @zrxtoken = token
      buy_orders = Order.select("type,price,sum(amount) as amount, min(expire) as expire").where(base_token:base_token,token_symbol:token_symbol,type:1).group("price").order(price: :desc)
      sell_orders = Order.select("type,price,sum(amount) as amount, min(expire) as expire").where(base_token:base_token,token_symbol:token_symbol,type:0 ).group("price").order(price: :asc)
      # max_amount = Order.select("sum(amount) as amount").where(base_token:base_token,token_symbol:token_symbol).maximum("amount")
      buy_max = Order.select("sum(amount) as mamount").where(base_token:base_token,token_symbol:token_symbol,type:1).group("price").order("mamount DESC").first
      sell_max = Order.select("sum(amount) as mamount").where(base_token:base_token,token_symbol:token_symbol,type:0).group("price").order("mamount DESC").first
      best_asks = Order.where(base_token:base_token,token_symbol:token_symbol,type:0).minimum("price");
      best_bids = Order.where(base_token:base_token,token_symbol:token_symbol,type:1).maximum("price");
      max_amount = 0
      if sell_max && buy_max
        if buy_max.mamount > sell_max.mamount
          max_amount = buy_max.mamount
        else
          max_amount = sell_max.mamount
        end
      elsif sell_max == nil && buy_max != nil
        max_amount = buy_max.mamount
      elsif sell_max != nil && buy_max == nil
        max_amount = sell_max.mamount
      end
      total_volume = 0
      buy_orders.each_with_index do |token, index|
        volume = BigDecimal.new(token.price.to_s) * BigDecimal.new(token.amount.to_s)
        total_volume += BigDecimal.new(volume)
      end
      sell_orders.each_with_index do |token, index|
        volume = BigDecimal.new(token.price.to_s) * BigDecimal.new(token.amount.to_s)
        total_volume += BigDecimal.new(volume)
      end
      @buy_orders = Array.new
      buy_orders.each_with_index do |token, index|
        decimal = get_decimals_places(token.price)
        zero_count = maker_zero(decimal)
        pro = amount_pro(token.amount,buy_max.mamount).to_s
        volume = BigDecimal.new(token.price.to_s) * BigDecimal.new(token.amount.to_s)
        depth = volume_pro(total_volume,volume).to_s
        json_record = {
          "zero_count" => zero_count,
          "depth" => depth.to_s,
          "pro" => pro,
          "price" => token.price,
          "amount" => token.amount,
        }
        @buy_orders.push json_record
      end
      @sell_orders = Array.new
      sell_orders.each_with_index do |token, index|
        decimal = get_decimals_places(token.price)
        zero_count = maker_zero(decimal)
        pro = amount_pro(token.amount,sell_max.mamount).to_s
        volume = BigDecimal.new(token.price.to_s) * BigDecimal.new(token.amount.to_s)
        depth = volume_pro(total_volume,volume).to_s
        json_record = {
          "zero_count" => zero_count,
          "depth" => depth.to_s,
          "pro" => pro,
          "price" => token.price,
          "amount" => token.amount,
        }
        @sell_orders.push json_record
      end

      trade_histories = TradeHistory.where(base_token:base_token,token_symbol:token_symbol).limit(100).order(updated_at: :desc)
      @trade_histories = Array.new
      trade_histories.each_with_index do |trade, index|
        time_format = get_timeformat(trade.created_at)
        json_record = {
          "time" => time_format,
          "price" => trade.price,
          "amount" => trade.amount,
        }
        @trade_histories.push json_record
      end
    else
      @zrxtoken = Token.where("symbol = ?","ZRX").first
      buy_orders = Order.select("type,price,sum(amount) as amount, min(expire) as expire").where(base_token:base_token,token_symbol:"ZRX",type:1).group("price").order(price: :desc)
      sell_orders = Order.select("type,price,sum(amount) as amount, min(expire) as expire").where(base_token:base_token,token_symbol:"ZRX",type:0 ).group("price").order(price: :asc)
      # max_amount = Order.select("sum(amount) as amount").where(base_token:base_token,token_symbol:token_symbol).maximum("amount")
      buy_max = Order.select("sum(amount) as mamount").where(base_token:base_token,token_symbol:"ZRX",type:1).group("price").order("mamount DESC").first
      sell_max = Order.select("sum(amount) as mamount").where(base_token:base_token,token_symbol:"ZRX",type:0).group("price").order("mamount DESC").first
      best_asks = Order.where(base_token:base_token,token_symbol:"ZRX",type:0).minimum("price");
      best_bids = Order.where(base_token:base_token,token_symbol:"ZRX",type:1).maximum("price");
      max_amount = 0
      if sell_max && buy_max
        if buy_max.mamount > sell_max.mamount
          max_amount = buy_max.mamount
        else
          max_amount = sell_max.mamount
        end
      elsif sell_max == nil && buy_max != nil
        max_amount = buy_max.mamount
      elsif sell_max != nil && buy_max == nil
        max_amount = sell_max.mamount
      end

      @buy_orders = Array.new
      buy_orders.each_with_index do |token, index|
        json_record = {
          "price" => token.price,
          "amount" => token.amount,
        }
        @buy_orders.push json_record
      end
      @sell_orders = Array.new
      sell_orders.each_with_index do |token, index|
        json_record = {
          "price" => token.price,
          "amount" => token.amount,
        }
        @sell_orders.push json_record
      end
    end
    # Convert token contract address to
    @changed_contract = change_contract_address(@zrxtoken.contract_address)
    @user_id = current_user ? current_user.id : nil
  end
  def get_users
    referral_id  = params[:referral_id]
    refer_users = User.where("recommended_id = ?", referral_id).order(created_at: :asc)
    if refer_users.length > 0
      wallet = Array.new
      commission_array = Array.new
      refer_users.each_with_index do |refer_user, index|
        wallet[index] = refer_user.wallet_address
      end
      commissions = TradeHistory.where("base_token = ? AND (maker_address IN (?) OR taker_address IN (?))","WETH",wallet,wallet).order(created_at: :desc).first(100)
      commissions.each_with_index do |commission, index|
        referral_user = User.where("wallet_address = ?",commission.maker_address).first
        if referral_user
          refer_id = referral_user.referral_id
          if refer_id == referral_id
            refer_id = User.where("wallet_address = ?",commission.taker_address).first.referral_id
          else
            if wallet.include? referral_user.wallet_address
              refer_id = User.where("wallet_address = ?",commission.maker_address).first.referral_id
            else
              refer_id = User.where("wallet_address = ?",commission.taker_address).first.referral_id
            end
          end
        else
          referral_user = User.where("wallet_address = ?",commission.taker_address).first
          refer_id = referral_user.referral_id
          if refer_id == referral_id
            refer_id = User.where("wallet_address = ?",commission.maker_address).first.referral_id
          else
            refer_id = User.where("wallet_address = ?",commission.taker_address).first.referral_id
          end
        end
        json_record = {
          "price" => commission.price,
          "amount" => commission.amount,
          "referral_id" => refer_id,
          "time" => commission.created_at
        }
        commission_array.push json_record
      end
      json_data = {
        "state":"OK",
        "refer_users":refer_users,
        "commissions":commission_array
      }
    else
      json_data = {
        "state":"OK",
      }
    end
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_tokens
    base_token = params[:base_token]
    tokens = Token.order(symbol: :asc)
    tokens_array = Array.new
    tokens.each_with_index do |token, index|
      if base_token == "WETH"
        t_last_price = token.last_price_weth
        t_h_price = token.h_price_weth
        t_h_volume = token.h_volume_weth
      elsif base_token == "TM"
        t_last_price = token.last_price_tm
        t_h_price = token.h_price_tm
        t_h_volume = token.h_volume_tm
      elsif base_token == "USDC"
        t_last_price = token.last_price_usdc
        t_h_price = token.h_price_usdc
        t_h_volume = token.h_volume_usdc
      elsif base_token == "WBTC"
        t_last_price = token.last_price_wbtc
        t_h_price = token.h_price_wbtc
        t_h_volume = token.h_volume_wbtc
      end
      json_record = {
        :symbol => token.symbol,
        :decimals => token.token_decimals,
        :contract_address => token.contract_address,
        :name => token.name,
        :last_price => t_last_price,
        :h_price => t_h_price,
        :h_volume => t_h_volume
      }
      tokens_array.push json_record
    end
    json_data = {
      "state":"ok",
      "tokens":tokens_array,
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end

  def get_market
    base_token = params[:base_token]
    sort = params[:sort]
    order = params[:order]
    if base_token == "WETH"
      tokens = Token.where("symbol != ?","WETH").order("#{sort} #{order}")
    elsif base_token == "TM"
      tokens = Token.where("tm_field = ?", 1).order("#{sort} #{order}")
    elsif base_token == "USDC"
      tokens = Token.where("usdc_field = ?", 1).order("#{sort} #{order}")
    elsif base_token == "WBTC"
      tokens = Token.where("wbtc_field = ?", 1).order("#{sort} #{order}")
    end
    result = "OK"

    tokens_array = Array.new
    tokens.each_with_index do |token, index|
      if base_token == "WETH"
        last_price = token.last_price_weth
        h_price = token.h_price_weth
        h_volume = token.h_volume_weth
      elsif base_token == "TM"
        last_price = token.last_price_tm
        h_price = token.h_price_tm
        h_volume = token.h_volume_tm
      elsif base_token == "USDC"
        last_price = token.last_price_usdc
        h_price = token.h_price_usdc
        h_volume = token.h_volume_usdc
      elsif base_token == "WBTC"
        last_price = token.last_price_wbtc
        h_price = token.h_price_wbtc
        h_volume = token.h_volume_wbtc
      end
      json_record = {
        :id => token.id,
        :symbol => token.symbol,
        :decimals => token.token_decimals,
        :contract_address => token.contract_address,
        :name => token.name,
        :last_price => last_price != nil && last_price != 0.0  ? last_price : "--",
        :h_price => h_price != nil ? h_price : 0,
        :h_volume => h_volume ? h_volume : 0
      }
      tokens_array.push json_record
    end

    json_data = {
      "state":"ok",
      "tokens":tokens_array,
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end

  def send_mail
    user_name = params[:name]
    user_email = params[:email]
    contents = params[:contents]
    # Send mail to site
    UserMailer.contact_mail(user_name,user_email,contents).deliver

    json_data = {
      "state":"ok",
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_init_data
    base_token = params[:base_token]
    symbol = params[:token_symbol]
    token_addr = params[:token_address]
    tokens = Token.where("symbol != ?","WETH").order(created_at: :asc)
    tm_tokens = Token.where("tm_field = ?", 1).order(created_at: :asc)
    usdc_tokens = Token.where("usdc_field = ?", 1).order(created_at: :asc)
    wbtc_tokens = Token.where("wbtc_field = ?", 1).order(created_at: :asc)
    result = "OK"
    tokens_array = Array.new
    tokens.each_with_index do |token, index|
      # token.last_price_weth = token.last_price("WETH")
      # token.last_price_tm = token.last_price("TM")
      # token.last_price_usdc = token.last_price("USDC")

      # token.h_price_weth = token.h_price("WETH")
      # token.h_price_tm = token.h_price("TM")
      # token.h_price_usdc = token.h_price("USDC")

      # token.h_volume_weth = token.h_volume("WETH")
      # token.h_volume_tm = token.h_volume("TM")
      # token.h_volume_usdc = token.h_volume("USDC")
      # token.save
      json_record = {
        :id => token.id,
        :symbol => token.symbol,
        :decimals => token.token_decimals,
        :contract_address => token.contract_address,
        :name => token.name,
        # :last_price => token.last_price("WETH"),
        # :h_price => token.h_price("WETH"),
        # :h_volume => token.h_volume("WETH")
        :last_price => token.last_price_weth != nil && token.last_price_weth != 0.0  ? token.last_price_weth : "--",
        :h_price => token.h_price_weth != nil ? token.h_price_weth : 0,
        :h_volume => token.h_volume_weth ? token.h_volume_weth : 0
      }
      tokens_array.push json_record
    end
    tokens_array = tokens_array.sort_by!{ |k| k[:h_volume]}.reverse!
    tm_tokens_array = Array.new
    tm_tokens.each_with_index do |token, index|
      json_record = {
        :id => token.id,
        :symbol => token.symbol,
        :decimals => token.token_decimals,
        :contract_address => token.contract_address,
        :name => token.name,
        :last_price => token.last_price_tm != nil && token.last_price_tm != 0.0  ? token.last_price_tm : "--",
        :h_price => token.h_price_tm != nil ? token.h_price_tm : 0,
        :h_volume => token.h_volume_tm ? token.h_volume_tm : 0
      }
      tm_tokens_array.push json_record
    end
    tm_tokens_array = tm_tokens_array.sort_by!{ |k| k[:h_volume]}.reverse!
    usdc_tokens_array = Array.new
    usdc_tokens.each_with_index do |token, index|
      json_record = {
        :id => token.id,
        :symbol => token.symbol,
        :decimals => token.token_decimals,
        :contract_address => token.contract_address,
        :name => token.name,
        :last_price => token.last_price_usdc != nil && token.last_price_usdc != 0.0 ? token.last_price_usdc : "--",
        :h_price => token.h_price_usdc != nil ? token.h_price_usdc : 0,
        :h_volume => token.h_volume_usdc ? token.h_volume_usdc : 0
      }
      usdc_tokens_array.push json_record
    end
    usdc_tokens_array = usdc_tokens_array.sort_by!{ |k| k[:h_volume]}.reverse!
    wbtc_tokens_array = Array.new
    wbtc_tokens.each_with_index do |token, index|
      json_record = {
        :id => token.id,
        :symbol => token.symbol,
        :decimals => token.token_decimals,
        :contract_address => token.contract_address,
        :name => token.name,
        :last_price => token.last_price_wbtc != nil && token.last_price_wbtc != 0.0 ? token.last_price_wbtc : "--",
        :h_price => token.h_price_wbtc != nil ? token.h_price_wbtc : 0,
        :h_volume => token.h_volume_wbtc ? token.h_volume_wbtc : 0
      }
      wbtc_tokens_array.push json_record
    end
    wbtc_tokens_array = wbtc_tokens_array.sort_by!{ |k| k[:h_volume]}.reverse!

    # Select token info
    token = Token.where(:symbol => symbol).first
    if token
      if base_token == "WETH"
        t_last_price = token.last_price_weth
        t_h_price = token.h_price_weth
        t_h_volume = token.h_volume_weth
      elsif base_token == "TM"
        t_last_price = token.last_price_tm
        t_h_price = token.h_price_tm
        t_h_volume = token.h_volume_tm
      elsif base_token == "USDC"
        t_last_price = token.last_price_usdc
        t_h_price = token.h_price_usdc
        t_h_volume = token.h_volume_usdc
      elsif base_token == "WBTC"
        t_last_price = token.last_price_wbtc
        t_h_price = token.h_price_wbtc
        t_h_volume = token.h_volume_wbtc
      end
      token_info = {
        "token_contract_addr":token.contract_address,
        "token_name":token.name,
        "token_decimals":token.token_decimals,
        "token_symbol":token.symbol,
        "token_last_price":t_last_price,
        "token_h_price":t_h_price,
        "token_h_volume":t_h_volume,
        "base_token":base_token
      }
    else
      abi = $token_abi
      exchangeContract = $web3.eth.contract(abi).at(token_addr)
      token_decimals = exchangeContract.decimals()
      token_name = exchangeContract.name()
      last_price = token_last_price(base_token,symbol)
      h_price = token_h_price(base_token,symbol)
      h_volume = token_h_volume(base_token,symbol)
      token_info = {
        "token_contract_addr":token_addr,
        "token_name":token_name,
        "token_symbol":symbol,
        "token_decimals":token_decimals,
        "token_last_price":last_price,
        "token_h_price":h_price,
        "token_h_volume":h_volume,
        "base_token":base_token
      }
    end

    json_data = {
      "state":"ok",
      "tokens":tokens_array,
      "tm_tokens":tm_tokens_array,
      "usdc_tokens":usdc_tokens_array,
      "wbtc_tokens":wbtc_tokens_array,
      "select_token":token_info
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def getFilledAmount(order_detail)
    abi = $exchange_abi
    myContract = $web3.eth.contract(abi)
    contract_instance =myContract.at($exchange_contract_addr)
    orderAddresses = Array.new(5)
    orderValues = Array.new(6)
    orderAddresses[0] = (order_detail["maker"])
    orderAddresses[1] = (order_detail["taker"])
    orderAddresses[2] = (order_detail["makerTokenAddress"])
    orderAddresses[3] = (order_detail["takerTokenAddress"])
    orderAddresses[4] = (order_detail["feeRecipient"])
    orderValues[0] = order_detail["makerTokenAmount"].to_i
    orderValues[1] = order_detail["takerTokenAmount"].to_i
    orderValues[2] = order_detail["makerFee"].to_i
    orderValues[3] = order_detail["takerFee"].to_i
    orderValues[4] = order_detail["expirationUnixTimestampSec"].to_i
    orderValues[5] = order_detail["salt"].to_i

    amount = 0
    order_hash = contract_instance.getOrderHash(orderAddresses,orderValues)
    amount = contract_instance.getUnavailableTakerTokenAmount(order_hash)
    return amount
  end
  def max_value(a,b)
    return a >= b ? a : b
  end
  def min_value(a,b)
    return a < b ? a : b
  end
  # Hash 32 byte fill zero
  def hash32(string)
    num = 64-string.length
    i = 0
    while i < num.to_i do
      string.insert(0,"0")
      i += 1
    end
    return string
  end
  def hash32_prefix string
    string.insert(-1,"0")
    num = 64 -string.length
    i = 0
    while i < num.to_i do
      string.insert(0,"0")
      i += 1
    end
    return string
  end
  def getRealAmount(type,order_detail)
    # init contract abi
    abi = $exchange_abi
    myContract = $web3.eth.contract(abi)
    contract_instance =myContract.at($exchange_contract_addr)
    # get filled amount
    filledAmount = getFilledAmount(order_detail)
    restAmount = order_detail["takerTokenAmount"].to_i - filledAmount

    if restAmount == 0
      return 0
    else
      if type == 0
        restTokenAmount = getPartialAmount(restAmount.to_i,order_detail["takerTokenAmount"].to_i,order_detail["makerTokenAmount"].to_i)


      elsif type == 1
        restTokenAmount = restAmount
      end
      return restTokenAmount
    end

  end
  def checkRestAmount(restmaker,resttaker,maker,taker)
    # init contract abi
    abi = $exchange_abi
    myContract = $web3.eth.contract(abi)
    contract_instance =myContract.at($exchange_contract_addr)
    check_amount = getPartialAmount(restmaker,maker,taker)

    if check_amount == resttaker
      return 0
    else
      return (resttaker - check_amount).to_i
    end
  end
  def getTokenDecimals(address)
    abi = $token_abi
    tokenContract = $web3.eth.contract(abi).at(address)
    decimals = tokenContract.decimals()
    return decimals
  end
  def fill_order
    base_token = "WETH"
    token_symbol = "ZRX"
    price = 0.028
    type = 1
    match_order = Order.where("base_token = ? AND token_symbol = ? AND price >= ?",base_token,token_symbol,price).first
    function_name = ""
    if match_order
      result = "YES"
      order_detail_id = match_order.detail_id
      signed_order = JSON.parse(OrderDetail.where(id:order_detail_id).first.signedorder)
      orderAddresses = Array.new
      orderValues = Array.new
      paramsArray = Array.new
      shouldThrowOnInsufficientBalanceOrAllowance = true
      fillTakerTokenAmount = signed_order["takerTokenAmount"]
      paramsArray[0] = orderAddresses[0] = signed_order["maker"]
      paramsArray[1] = orderAddresses[1] = signed_order["taker"]
      paramsArray[2] = orderAddresses[2] = signed_order["makerTokenAddress"]
      paramsArray[3] = orderAddresses[3] = signed_order["takerTokenAddress"]
      paramsArray[4] = orderAddresses[4] = signed_order["feeRecipient"]

      paramsArray[5] = orderValues[0] = signed_order["makerTokenAmount"]
      paramsArray[6] = orderValues[1] = signed_order["takerTokenAmount"]
      paramsArray[7] = orderValues[2] = signed_order["makerFee"]
      paramsArray[8] = orderValues[3] = signed_order["takerFee"]
      paramsArray[9] = orderValues[4] = signed_order["expirationUnixTimestampSec"]
      paramsArray[10] = orderValues[5] = signed_order["salt"]
      v = signed_order["ecSignature"]["v"]
      r = signed_order["ecSignature"]["r"]
      s = signed_order["ecSignature"]["s"]

      paramsArray[11] = signed_order["takerTokenAmount"]
      paramsArray[12] = 1

      key = Eth::Key.new priv: $server_key
      function_name = $hash_function_name["fillOrder"]
      count = $web3.eth.getTransactionCount([key.address,"pending"]).to_i(16)
      contract_address = $exchange_contract_addr

      j = 0
      while j < 5 do
        paramsArray[j] = $web3.eth.remove_0x_head(orderAddresses[j])
        j += 1
      end
      i = 0
      while i < 8 do
        paramsArray[i+5] = paramsArray[i+5].to_i.to_s(16)
        i += 1
      end
      k = 0
      paramsArray[13] = v.to_i.to_s(16)
      paramsArray[14] = $web3.eth.remove_0x_head(r)
      paramsArray[15] = $web3.eth.remove_0x_head(s)
      while k < 16 do
        paramsArray[k] = hash32 paramsArray[k]
        function_name.insert(-1,paramsArray[k])
        k += 1
      end
      tx = Eth::Tx.new({
        value:0,
        gas_limit: 2100_00,
        gas_price: 20000000000,
        nonce: count,
        to: contract_address,
        data:function_name,
      })
      tx.sign key
      $web3.eth.sendRawTransaction([tx.hex])
      result = tx.hash

    else
      result = "NO"
    end
    return result

  end
  def send_tm_token(value = 100,wallet_addr)
    # token_address = '0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d' # ZRX token address
    contract_address = $tm_token_addr
    key = Eth::Key.new priv: $server_key
    decimal = $tm_token_decimals
    # convert token amount to BigDecimal value
    big_value = value * (10 ** decimal)

    big_value_string = big_value.to_i.to_s(16)
    big_value_param = hash32 big_value_string
    # get nonce count
    if $lastTxHash
      trade_history = TradeHistory.where('created_at > ?', $lastTxHashDate).order(created_at: :desc).first;
    else
      trade_history = TradeHistory.all.order(created_at: :desc).first;
    end

    if trade_history
      $lastTxHash = trade_history.txHash
      $lastTxHashDate = trade_history.created_at
    end

    count = $web3.eth.getTransactionCount([key.address,"pending"]).to_i(16)
    if $lastTxHash
      tx = $web3.eth.getTransactionByHash($lastTxHash)
      if tx
        txnonce = tx.nonce.to_i(16)
        count = count > (txnonce + 1) ? count : txnonce + 1
      end
    end

    # params
    spender_address = wallet_addr
    function_name = '';
    function_name = "0xa9059cbb" # approve function name

    # make approve function params
    spender_address = hash32 $web3.eth.remove_0x_head(spender_address)
    address_param = hash32 spender_address
    function_name.insert(-1,address_param)
    function_name.insert(-1,big_value_param)

    gas_price = ($web3.eth.gasPrice()).to_i(16)
    # gas_price = 11000;
    gas_limit = 210000;

    tx = Eth::Tx.new({
      value:0,
      gas_limit: gas_limit,
      gas_price: gas_price,
      nonce: count,
      to: contract_address,
      data:function_name,
    })
    tx.sign key
    $web3.eth.sendRawTransaction([tx.hex])
    result = tx.hash
    $lastTxHash = tx.hash
    $lastTxHashDate = Time.current
    # result = "result"
    # result = $web3.eth.getTransactionByHash tx.hash
    return result
  end
  def getTokenAllowance token_addr
    abi = $token_abi
    # token_addr = "0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d"  # Zrx token address
    spender_address = $token_contract_addr
    exchangeContract = $web3.eth.contract(abi).at(token_addr)
    balance = exchangeContract.allowance($wallet_address,spender_address)
    return balance
  end
  def getPartialAmount(num,denominator,target)
    amount = ((num * target) / denominator).to_i
    return amount
  end
  def batchfillOrder(type,price,amount,base_token='WETH',token_symbol='ZRX')
    return_str = ""
    # init Arrays
    signed_order = Array.new
    signed_order_ids = Array.new
    delete_order = Array.new
    update_order = Array.new
    order_real_amountArray = Array.new
    update_order_amount = BigDecimal.new("0")
    update_taker_order = Array.new
    update_taker_order_amount = BigDecimal.new("0")
    taker_amount = BigDecimal.new(amount.to_s)
    maker_amount = BigDecimal.new("0")
    result = ""
    data_code = ""

    # Init Contract define
    abi = $exchange_abi
    myContract = $web3.eth.contract(abi)
    contract_instance = myContract.at($exchange_contract_addr)
    # get taker Order values
    create_order = Order.where("base_token = ? AND token_symbol = ? AND price = ? AND type = ?",base_token,token_symbol,price,type).last
    if create_order
      signed_order[0] = JSON.parse(OrderDetail.where(id:create_order.detail_id).first.signedorder)
      signed_order_ids[0] = create_order.id
      # Get Token Decimals From Token Address
      if type == 1
        token_address = signed_order[0]["takerTokenAddress"]
      elsif type == 0
        token_address = signed_order[0]["makerTokenAddress"]
      end
      decimals = getTokenDecimals(token_address)

      order_real_amountArray[0] = create_order.amount * ( 10 ** decimals )
      taker_amount = order_real_amountArray[0]
      # Get Token decimals from Ether block
      # Sell Order Case
      if type == 0
        # Get matching orders
        match_order = Order.where("base_token = ? AND token_symbol = ? AND price >= ? AND type = ?",base_token,token_symbol,price,1).order(price: :desc)
        # If exists matching orders
        if match_order.length > 0
          i = 0
          while i < match_order.length do
            # maker_amount += BigDecimal.new(match_order[i].amount.to_s)
            match_order_detail = JSON.parse(OrderDetail.where(id:match_order[i].detail_id).first.signedorder)

            order_real_amountArray[i+1] = match_order[i].amount * ( 10 ** decimals )
            # get real rest token amount
            orderRealAmount = getRealAmount(1,match_order_detail)
            order_real_amountArray[i+1] = min_value(order_real_amountArray[i+1], orderRealAmount)
            if(order_real_amountArray[i + 1] != 0)
              signed_order[i + 1] = match_order_detail
              signed_order_ids[i + 1] = match_order[i].id
              maker_amount += order_real_amountArray[i+1]
            else
              delete_order[i+1] = match_order[i]
              i += 1
              next
            end
            if maker_amount >= taker_amount
              if maker_amount == taker_amount
                delete_order[i+1] = match_order[i]
              else
                update_order[0] = match_order[i]
                update_order_amount = (maker_amount - taker_amount).to_i
              end
              break
            else
              delete_order[i+1] = match_order[i]
            end
            i += 1
          end
          if taker_amount > maker_amount
            update_taker_order_amount = taker_amount - maker_amount
          end
        end
      elsif type == 1
        match_order = Order.where("base_token = ? AND token_symbol = ? AND price <= ? AND type = ?",base_token,token_symbol,price,0).order(price: :asc)
        if match_order.length > 0
          i = 0
          while i < match_order.length do
            # maker_amount += BigDecimal.new(match_order[i].amount.to_s)
            match_order_detail = JSON.parse(OrderDetail.where(id:match_order[i].detail_id).first.signedorder)
            order_real_amountArray[i+1] = match_order[i].amount * ( 10 ** decimals )
            orderRealAmount = getRealAmount(0,match_order_detail)
            order_real_amountArray[i+1] = min_value(order_real_amountArray[i+1], orderRealAmount)
            if(order_real_amountArray[i + 1] != 0)
              signed_order[i + 1] = match_order_detail
              signed_order_ids[i + 1] = match_order[i].id
              maker_amount += order_real_amountArray[i+1]
            else
              delete_order[i+1] = match_order[i]
              i += 1
              next
            end
            if maker_amount >= taker_amount
              if maker_amount == taker_amount
                delete_order[i+1] = match_order[i]
              else
                update_order[0] = match_order[i]
                update_order_amount = (maker_amount - taker_amount).to_i
              end
              break
            else
              delete_order[i+1] = match_order[i]
            end
            i += 1
          end
          if taker_amount > maker_amount
            update_taker_order_amount = taker_amount - maker_amount
          end
        end
      end
      if signed_order.count > 1
        delete_order[0] = create_order
        order_count = signed_order.count
        # make param prefix
        prefix_param = Array.new
        prefix_params = ""
        data_code = ""
        key = Eth::Key.new priv: $server_key
        # batchfillOrKillOrders
        # data_code = "0x4f150787"
        # batchfillOrders
        data_code = "0x4f150787"
        count = ($web3.eth.getTransactionCount([key.address,"pending"]).to_i(16))
        contract_address = $exchange_contract_addr
        prefix_param[0] = 0xc
        prefix_param[1] = prefix_param[0] + 5 * 2 * order_count + 2
        prefix_param[2] = prefix_param[1] + 6 * 2 * order_count + 2
        prefix_param[3] = prefix_param[2] + 1 * 2 * order_count + 2
        prefix_param[4] = prefix_param[3] + 1 * 2 * order_count + 2
        prefix_param[5] = prefix_param[4] + 1 * 2 * order_count + 2
        i = 0
        while i < 3 do
          param = prefix_param[i].to_i.to_s(16)
          param = hash32_prefix(param)
          prefix_param[i] = param
          prefix_params += prefix_param[i]
          i += 1
        end

        # prefix_params += hash32(1.to_i.to_s(16))
        i = 0
        while i < 3 do
          param = prefix_param[i+3].to_i.to_s(16)
          param = hash32_prefix(param)
          prefix_param[i+3] = param
          prefix_params += prefix_param[i+3]
          i += 1
        end
        orderAddresses = Array.new(order_count){Array.new}
        orderValues = Array.new(order_count){Array.new}
        paramsArray = Array.new(order_count){Array.new}
        tmp_paramArray = Array.new{Array.new}
        v = Array.new(order_count){Array.new}
        r = Array.new(order_count){Array.new}
        s = Array.new(order_count){Array.new}
        j = 0
        while j < order_count do
          paramsArray[j][0] = orderAddresses[j][0] = $web3.eth.remove_0x_head(signed_order[j]["maker"])
          paramsArray[j][1] = orderAddresses[j][1] = $web3.eth.remove_0x_head(signed_order[j]["taker"])
          paramsArray[j][2] = orderAddresses[j][2] = $web3.eth.remove_0x_head(signed_order[j]["makerTokenAddress"])
          paramsArray[j][3] = orderAddresses[j][3] = $web3.eth.remove_0x_head(signed_order[j]["takerTokenAddress"])
          paramsArray[j][4] = orderAddresses[j][4] = $web3.eth.remove_0x_head(signed_order[j]["feeRecipient"])

          paramsArray[j][5] = orderValues[j][0] = signed_order[j]["makerTokenAmount"].to_i.to_s(16)
          paramsArray[j][6] = orderValues[j][1] = signed_order[j]["takerTokenAmount"].to_i.to_s(16)
          paramsArray[j][7] = orderValues[j][2] = signed_order[j]["makerFee"].to_i.to_s(16)
          paramsArray[j][8] = orderValues[j][3] = signed_order[j]["takerFee"].to_i.to_s(16)
          paramsArray[j][9] = orderValues[j][4] = signed_order[j]["expirationUnixTimestampSec"].to_i.to_s(16)
          paramsArray[j][10] = orderValues[j][5] = signed_order[j]["salt"].to_i.to_s(16)
          v[j] = signed_order[j]["ecSignature"]["v"]
          r[j] = signed_order[j]["ecSignature"]["r"]
          s[j] = signed_order[j]["ecSignature"]["s"]
          if j == 0
            if update_taker_order_amount > 0
              if type == 0
                fillMakerTokenAmount = maker_amount.to_i
                fillTakerTokenAmount = getPartialAmount(fillMakerTokenAmount,signed_order[j]["makerTokenAmount"].to_i,signed_order[j]["takerTokenAmount"].to_i)
                filled_Maker_tmp = getPartialAmount(fillTakerTokenAmount,signed_order[j]["takerTokenAmount"].to_i,signed_order[j]["makerTokenAmount"].to_i)

                if fillMakerTokenAmount == filled_Maker_tmp
                  paramsArray[j][11] = (fillTakerTokenAmount).to_i.to_s(16)
                else
                  paramsArray[j][11] =  (fillTakerTokenAmount + fillMakerTokenAmount - filled_Maker_tmp).to_i.to_s(16)
                end
              elsif type == 1
                fillTakerTokenAmount = maker_amount.to_i
                return_str += "-fillTaker-->"
                return_str += fillTakerTokenAmount.to_s
                fillMakerTokenAmount = getPartialAmount(fillTakerTokenAmount.to_i,signed_order[j]["takerTokenAmount"].to_i,signed_order[j]["makerTokenAmount"].to_i)
                filled_Taker_tmp = getPartialAmount(fillMakerTokenAmount.to_i,signed_order[j]["makerTokenAmount"].to_i,signed_order[j]["takerTokenAmount"].to_i)
                taker_amount = min_value(fillTakerTokenAmount.to_i,filled_Taker_tmp.to_i)
                paramsArray[j][11] = fillTakerTokenAmount.to_i.to_s(16)
              end
            else
              if type == 0
                paramsArray[j][11] = (signed_order[j]["takerTokenAmount"]).to_i.to_s(16)
              elsif type == 1
                paramsArray[j][11] = (signed_order[j]["takerTokenAmount"]).to_i.to_s(16)
              end
            end
          else
            if update_order.count > 0
              if update_order[0].id == signed_order_ids[j]
                if type == 0   # SELL
                  # BUY order current
                  taker_Token_amount = order_real_amountArray[j]
                  fillTakerTokenAmount = (taker_Token_amount.to_i - (update_order_amount.to_i))
                  filledMakerTokenAmount = (signed_order[j]["makerTokenAmount"].to_i * fillTakerTokenAmount / signed_order[j]["takerTokenAmount"].to_i).to_i
                  filledTakerTokenAmount = (signed_order[j]["takerTokenAmount"].to_i * filledMakerTokenAmount / signed_order[j]["makerTokenAmount"].to_i).to_i
                  taker_amount = min_value(fillTakerTokenAmount, filledTakerTokenAmount)
                  paramsArray[j][11] = taker_amount.to_i.to_s(16)
                elsif type == 1   #BUY
                  # SELL order current
                  maker_Token_amount = order_real_amountArray[j]

                  # get filled amount in order
                  filledTakerTokenAmount = getFilledAmount(signed_order[j])
                  filledMakerTokenAmount = getPartialAmount(filledTakerTokenAmount,signed_order[j]["takerTokenAmount"].to_i,signed_order[j]["makerTokenAmount"].to_i)
                  # get current token amounts
                  restMakerTokenAmount = min_value((signed_order[j]["makerTokenAmount"].to_i - filledMakerTokenAmount),(maker_Token_amount))
                  fillMakerTokenAmount = (restMakerTokenAmount - update_order_amount ).to_i

                  fillTakerTokenAmount = getPartialAmount(fillMakerTokenAmount.to_i,signed_order[j]["makerTokenAmount"].to_i,signed_order[j]["takerTokenAmount"].to_i)
                  tmp = ((fillMakerTokenAmount.to_i * signed_order[j]["takerTokenAmount"].to_i) / signed_order[j]["makerTokenAmount"].to_i).to_i
                  tmp_Maker = getPartialAmount(fillTakerTokenAmount,signed_order[j]["takerTokenAmount"].to_i,signed_order[j]["makerTokenAmount"].to_i)

                  if tmp_Maker == fillMakerTokenAmount
                    paramsArray[j][11] = (fillTakerTokenAmount).to_i.to_s(16)
                  else
                    paramsArray[j][11] = (fillTakerTokenAmount + (fillMakerTokenAmount-tmp_Maker).to_i).to_i.to_s(16)
                  end
                end
              else
                if type == 1
                  fillMakerTokenAmount = order_real_amountArray[j].to_i
                  fillTakerTokenAmount = (signed_order[j]["takerTokenAmount"].to_i * fillMakerTokenAmount / signed_order[j]["makerTokenAmount"].to_i).to_i
                  filledMakerTokenAmount = (signed_order[j]["makerTokenAmount"].to_i * fillTakerTokenAmount / signed_order[j]["takerTokenAmount"].to_i).to_i
                  if filledMakerTokenAmount == fillMakerTokenAmount
                    paramsArray[j][11] = (fillTakerTokenAmount).to_i.to_s(16)
                  else
                    paramsArray[j][11] = (fillTakerTokenAmount + (fillMakerTokenAmount-filledMakerTokenAmount).to_i).to_i.to_s(16)
                  end
                # paramsArray[j][11] = taker_Token_amount.to_i.to_s(16)
                elsif type == 0
                  fillTakerTokenAmount = order_real_amountArray[j].to_i
                  fillMakerTokenAmount = (signed_order[j]["makerTokenAmount"].to_i * fillTakerTokenAmount / signed_order[j]["takerTokenAmount"].to_i).to_i
                  filledTakerTokenAmount = (signed_order[j]["takerTokenAmount"].to_i * fillMakerTokenAmount / signed_order[j]["makerTokenAmount"].to_i).to_i
                  taker_amount = min_value(fillTakerTokenAmount,filledTakerTokenAmount)
                  paramsArray[j][11] = fillTakerTokenAmount.to_i.to_s(16)
                end
              end
            else
              if type == 1
                fillMakerTokenAmount = order_real_amountArray[j].to_i
                fillTakerTokenAmount = (signed_order[j]["takerTokenAmount"].to_i * fillMakerTokenAmount / signed_order[j]["makerTokenAmount"].to_i).to_i
                filledMakerTokenAmount = (signed_order[j]["makerTokenAmount"].to_i * fillTakerTokenAmount / signed_order[j]["takerTokenAmount"].to_i).to_i
                if filledMakerTokenAmount == fillMakerTokenAmount
                  paramsArray[j][11] = (fillTakerTokenAmount).to_i.to_s(16)
                else
                  paramsArray[j][11] = (fillTakerTokenAmount + (fillMakerTokenAmount-filledMakerTokenAmount).to_i).to_i.to_s(16)
                end
                # paramsArray[j][11] = taker_Token_amount.to_i.to_s(16)
              elsif type == 0
                fillTakerTokenAmount = order_real_amountArray[j].to_i
                fillMakerTokenAmount = (signed_order[j]["makerTokenAmount"].to_i * fillTakerTokenAmount / signed_order[j]["takerTokenAmount"].to_i).to_i
                filledTakerTokenAmount = (signed_order[j]["takerTokenAmount"].to_i * fillMakerTokenAmount / signed_order[j]["makerTokenAmount"].to_i).to_i
                taker_amount = min_value(fillTakerTokenAmount,filledTakerTokenAmount)
                paramsArray[j][11] = fillTakerTokenAmount.to_i.to_s(16)
              end
            end
          end

          paramsArray[j][12] = v[j].to_i.to_s(16)
          paramsArray[j][13] = $web3.eth.remove_0x_head(r[j])
          paramsArray[j][14] = $web3.eth.remove_0x_head(s[j])
          j += 1
        end
        # Change order arrays
        if type == 1
          tmp_paramArray = paramsArray[0]
          paramsArray[0] = paramsArray[order_count - 1]
          paramsArray[order_count - 1] = tmp_paramArray
        end
        order_count_string = order_count.to_i.to_s(16)
        order_count_param = hash32 order_count_string
        # make batchfillorder params
        # make param header
        data_code.insert(-1,prefix_params)
        # param orderAddress count
        data_code.insert(-1,order_count_param)
        # param orderAddresses
        ii = 0
        jj = 0
        while ii < order_count.to_i do
          while jj < 5 do
            paramsArray[ii][jj] = hash32 paramsArray[ii][jj]
            data_code.insert(-1,paramsArray[ii][jj])
            jj += 1
          end
          jj = 0
          ii += 1
        end
        # param orderValue count
        data_code.insert(-1,order_count_param)
        # param orderValues
        ii = 0
        jj = 0
        while ii < order_count do
          while jj < 6 do
            paramsArray[ii][jj + 5] = hash32 paramsArray[ii][jj + 5]
            data_code.insert(-1,paramsArray[ii][jj + 5])
            jj += 1
          end
          jj = 0
          ii += 1
        end
        # param takerfillamount count
        data_code.insert(-1,order_count_param)
        # param takerfillamounts
        ii = 0
        jj = 0
        while ii < order_count do
          while jj < 1 do
            paramsArray[ii][jj + 11] = hash32 paramsArray[ii][jj + 11]
            data_code.insert(-1,paramsArray[ii][jj + 11])
            jj += 1
          end
          jj = 0
          ii += 1
        end
        # data_code.insert(-1,hash32(1.to_i.to_s(16)))
        ii = 0
        jj = 0
        data_code.insert(-1,order_count_param)
        while ii < order_count do
          while jj < 1 do
            paramsArray[ii][jj + 12] = hash32 paramsArray[ii][jj + 12]
            data_code.insert(-1,paramsArray[ii][jj + 12])
            jj += 1
          end
          jj = 0
          ii += 1
        end
        # param s[v] count
        data_code.insert(-1,order_count_param)
        # param s[v]s
        ii = 0
        jj = 0
        while ii < order_count do
          while jj < 1 do
            paramsArray[ii][jj + 13] = hash32 paramsArray[ii][jj + 13]
            data_code.insert(-1,paramsArray[ii][jj + 13])
            jj += 1
          end
          jj = 0
          ii += 1
        end

        # param s[r] count
        data_code.insert(-1,order_count_param)
        # param s[r]s
        ii = 0
        jj = 0
        while ii < order_count do
          while jj < 1 do
            paramsArray[ii][jj + 14] = hash32 paramsArray[ii][jj + 14]
            data_code.insert(-1,paramsArray[ii][jj + 14])
            jj += 1
          end
          jj = 0
          ii += 1
        end
        # gas_price = ($web3.eth.gasPrice()).to_i(16)
        gas_price = 11000000000;
        gas_limit = 410000;

        tx = Eth::Tx.new({
          value:0,
          gas_limit: gas_limit,
          gas_price: gas_price,
          nonce: count,
          to: contract_address,
          data:data_code,
        })
        tx.sign key
        $web3.eth.sendRawTransaction([tx.hex])
        result = tx.hash
        if update_taker_order_amount > 0
          update_amount = BigDecimal.new(update_taker_order_amount.to_s) / (BigDecimal.new(10.to_s) ** BigDecimal.new(decimals.to_s))
          if decimals > 8
            update_amount = update_amount.truncate(8)
          else
            update_amount = update_amount.truncate(decimals)
          end

          if update_amount != 0
            update_orders(create_order.id,update_amount)
          else
            delete_orders(create_order.id)
          end
        else
          delete_orders(delete_order[0].id)
        end
        if delete_order.count > 1
          jj = 1
          while jj < delete_order.count do
            delete_orders(delete_order[jj].id)
            create_trade_histories(delete_order[jj].token_symbol,delete_order[jj].type,delete_order[jj].maker_address,create_order.maker_address,delete_order[jj].price,delete_order[jj].amount,delete_order[jj].base_token,result)
            jj += 1
          end
        end
        if update_order.count > 0
          update_amount = BigDecimal.new(update_order_amount.to_s) / (BigDecimal.new(10.to_s) ** BigDecimal.new(decimals.to_s))
          if decimals > 8
            update_amount = update_amount.truncate(8)
          else
            update_amount = update_amount.truncate(decimals)
          end
          if update_amount != 0
            update_orders(update_order[0].id,update_amount)
          else
            delete_orders(update_order[0].id)
          end
          trade_amount = update_order[0].amount - update_amount
          create_trade_histories(update_order[0].token_symbol,update_order[0].type,update_order[0].maker_address,create_order.maker_address,update_order[0].price,trade_amount,update_order[0].base_token,result)
        end

        return return_str
      else
        if delete_order.count > 0
          jj = 1
          while jj <= delete_order.count do
            if delete_order[jj]
              delete_orders(delete_order[jj].id)
            end
            jj += 1
          end
        end
        return "No match"
      end
    else
      return "No match"
    end
  end
  def setTokenAllowance token_address
    # token_address = '0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d' # ZRX token address
    contract_address = token_address
    key = Eth::Key.new priv: $server_key
    # get nonce count
    count = $web3.eth.getTransactionCount([key.address,"pending"]).to_i(16)
    # params
    spender_address = $token_contract_addr
    value = $set_allow_value
    function_name = '';
    function_name = "0x095ea7b3" # approve function name

    # make approve function params
    spender_address = hash32 $web3.eth.remove_0x_head(spender_address)
    function_name.insert(-1,spender_address)
    function_name.insert(-1,value)

    tx = Eth::Tx.new({
      value:0,
      gas_limit: 1100_00,
      gas_price: 20000000000,
      nonce: count,
      to: contract_address,
      data:function_name,
    })
    tx.sign key
    $web3.eth.sendRawTransaction([tx.hex])
    result = tx.hash
    # result = $web3.eth.getTransactionByHash tx.hash
    return result
  end
  def getTokenAllowance token_addr
    abi = $token_abi
    # token_addr = "0xa8e9fa8f91e5ae138c74648c9c304f1c75003a8d"  # Zrx token address
    spender_address = $token_contract_addr
    exchangeContract = $web3.eth.contract(abi).at(token_addr)
    balance = exchangeContract.allowance($wallet_address,spender_address)
    return balance
  end
  def get_token_info
    base_token = params[:base_token]
    symbol = params[:symbol]
    token_contract = params[:token_contract]
    token = Token.where(:symbol => symbol).first
    if token
      if base_token == "WETH"
        t_last_price = token.last_price_weth
        t_h_price = token.h_price_weth
        t_h_volume = token.h_volume_weth
      elsif base_token == "TM"
        t_last_price = token.last_price_tm
        t_h_price = token.h_price_tm
        t_h_volume = token.h_volume_tm
      elsif base_token == "USDC"
        t_last_price = token.last_price_usdc
        t_h_price = token.h_price_usdc
        t_h_volume = token.h_volume_usdc
      elsif base_token == "WBTC"
        t_last_price = token.last_price_wbtc
        t_h_price = token.h_price_wbtc
        t_h_volume = token.h_volume_wbtc
      end
      token_info = {
        "token_contract_addr":token.contract_address,
        "token_name":token.name,
        "token_symbol":token.symbol,
        "token_decimals":token.token_decimals,
        "token_last_price":t_last_price != nil && t_last_price != 0.0 ? t_last_price : "--",
        "token_h_price":t_h_price != nil && t_h_price != 0.0 ? t_h_price : "--",
        "token_h_volume":t_h_volume ? t_h_volume : 0
      }
      json_data = {
        "state":"ok",
        "token_info":token_info
      }
    else
      abi = $token_abi
      exchangeContract = $web3.eth.contract(abi).at(token_contract)
      token_decimals = exchangeContract.decimals()
      token_name = exchangeContract.name()
      last_price = token_last_price(base_token,symbol)
      h_price = token_h_price(base_token,symbol)
      h_volume = token_h_volume(base_token,symbol)
      token_info = {
        "token_contract_addr":token_contract,
        "token_name":token_name,
        "token_symbol":symbol,
        "token_decimals":token_decimals,
        "token_last_price":last_price,
        "token_h_price":h_price,
        "token_h_volume":h_volume
      }
      json_data = {
        "state":"ok",
        "token_info":token_info
      }

    end
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def find_token
    token_symbol = params[:token_symbol]
    base_token = params[:base_token]
    token = Token.where(:symbol => token_symbol).first
    last_price = token_last_price(base_token,token_symbol)
    h_price = token_h_price(base_token,token_symbol)
    h_volume = token_h_volume(base_token,token_symbol)
    if token
      json_data = {
        "status": "ok",
        "token": token,
        "l_price": last_price,
        "h_price": h_price,
        "h_volume": h_volume
      }
    else
      json_data = {
        "status": "no_data",
        "l_price": last_price,
        "h_price": h_price,
        "h_volume": h_volume
      }
    end
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def token_last_price(base_token = 'ETH', token_symbol)
    last = TradeHistory.where(token_symbol:token_symbol).last
    if last
      return last.price
    else
      return "--"
    end
  end
  def token_h_price(base_token = "ETH", token_symbol)
    h_price = TradeHistory.where("created_at > ? AND token_symbol = ?",Time.now.midnight,token_symbol).last
    if h_price
      pre_price = TradeHistory.where("created_at < ? AND token_symbol = ?",Time.now.midnight,token_symbol).order(created_at: :asc).last
      if pre_price
        procentage = (((h_price.price - pre_price.price) / pre_price.price) * 100).round(2)
      else
        return 100
      end
    else
      return "--"
    end
  end
  def token_h_volume(base_token = "ETH", token_symbol)
    volumes = TradeHistory.where("created_at > ? AND token_symbol = ?",Time.now.midnight,token_symbol)
    h_volume = 0.00
    if volumes.length > 0
      for volume in volumes
        h_volume += (volume.amount * volume.price)
      end
    end
    return h_volume.round(2)
  end
  def get_messages
    room_id = params[:param1]
    messages = Message.where(room_id: room_id ).order(created_at: :asc)
    json_data = Array.new
    messages.each_with_index do |message, index|
      json_record = {
          :content => message.content,
          :nick_name => message.user.nick_name,
          :contract_address => message.user.wallet_address
      }
      json_data.push json_record
    end
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_my_open_orders
    wallet_address = params[:wallet_addr]
    base_token = params[:base_token]
    token_symbol = params[:token_symbol]
    my_orders = Order.where(base_token:base_token,maker_address:wallet_address).order(created_at: :asc)
    if my_orders.length > 0
      json_data = {
        "status":"ok",
        "orders":my_orders
      }
    else
      json_data = {
        "status":"no_data"
      }
    end

    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_orders
    token_symbol = params[:symbol]
    base_token = params[:base_token]
    last_order = Order.select("price,type").where("base_token = ? AND token_symbol = ?",base_token,token_symbol).last
    if last_order
      if last_order.type == 1
        match_order = Order.where("base_token = ? AND token_symbol = ? AND price <= ? AND type = ?",base_token,token_symbol,last_order.price,0).order(price: :desc)
      elsif last_order.type == 0
        match_order = Order.where("base_token = ? AND token_symbol = ? AND price >= ? AND type = ?",base_token,token_symbol,last_order.price,1).order(price: :desc)
      end
    else
      matched = 0
    end
    if match_order
      if match_order.length > 0
        matched = 1
      else
        matched = 0
      end
    else
      matched = 0
    end
    last_day_trade = TradeHistory.where("created_at < ? AND token_symbol = ? AND base_token = ?",Time.now.midnight,token_symbol,base_token).order(created_at: :asc).last
    if last_day_trade
      last_day_price = last_day_trade.price
    else
      last_day_price = 0.0001
    end
    buy_orders = Order.select("type,price,sum(amount) as amount, min(expire) as expire").where(base_token:base_token,token_symbol:token_symbol,type:1).group("price").order(price: :desc)
    sell_orders = Order.select("type,price,sum(amount) as amount, min(expire) as expire").where(base_token:base_token,token_symbol:token_symbol,type:0 ).group("price").order(price: :asc)
    # max_amount = Order.select("sum(amount) as amount").where(base_token:base_token,token_symbol:token_symbol).maximum("amount")
    buy_max = Order.select("sum(amount) as mamount").where(base_token:base_token,token_symbol:token_symbol,type:1).group("price").order("mamount DESC").first
    sell_max = Order.select("sum(amount) as mamount").where(base_token:base_token,token_symbol:token_symbol,type:0).group("price").order("mamount DESC").first
    best_asks = Order.where(base_token:base_token,token_symbol:token_symbol,type:0).minimum("price");
    best_bids = Order.where(base_token:base_token,token_symbol:token_symbol,type:1).maximum("price");
    max_amount = 0
    if sell_max && buy_max
      if buy_max.mamount > sell_max.mamount
        max_amount = buy_max.mamount
      else
        max_amount = sell_max.mamount
      end
    elsif sell_max == nil && buy_max != nil
      max_amount = buy_max.mamount
    elsif sell_max != nil && buy_max == nil
      max_amount = sell_max.mamount
    end
    json_data = {
      "buy":buy_orders,
      "sell":sell_orders,
      "max_amount":max_amount,
      "best_asks":best_asks,
      "best_bids":best_bids,
      "last_price":last_day_price,
      "matched":matched

    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_owner_data
    account_address = params[:account_address]
    base_token = params[:base_token]
    my_orders = Order.where(base_token:base_token,maker_address:account_address).order(updated_at: :desc)
    order_exist = false
    trade_exist = false
    if my_orders.length > 0
      order_exist = true
    end
    my_trades = TradeHistory.where("base_token = ? AND maker_address = ? OR taker_address = ?",base_token,account_address,account_address).order(updated_at: :desc)
    if my_trades.length > 0
      trade_exist = true
    end
    json_data = {
      "order_exist":order_exist,
      "orders":my_orders,
      "trade_exist":trade_exist,
      "trades":my_trades
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end
  def get_matching_orders
    token_symbol = params[:symbol]
    trade = params[:trade]
    price = params[:price]
    amount = params[:amount]
    base_token = params[:base_token]
    if trade == "buy"
      type = 0
    else
      type = 1
    end
    order = Order.where(token_symbol:token_symbol,type:type,base_token:base_token,price:price,amount:amount ).first
    if order
      signed_order = OrderDetail.where(id:order.detail_id).first
      json_data = {
        "status":"matched",
        "data":signed_order
      }
      respond_to do |format|
        format.json { render :json => json_data}
      end
    else
      smile_order = Order.where(token_symbol:token_symbol,type:type,base_token:base_token,price:price).order(amount: :desc).first;
      if smile_order
        signed_order = OrderDetail.where(id:smile_order.detail_id).first
        if smile_order.amount > amount.to_f
          json_data = {
            "status":"large_match",
            "data":signed_order,
            "db_amount":smile_order.amount
          }
          respond_to do |format|
            format.json { render :json => json_data}
          end
        else
          json_data = {
            "status":"small_match",
            "data":signed_order,
            "db_amount":smile_order.amount
          }
          respond_to do |format|
            format.json { render :json => json_data}
          end
        end
      else
        json_data = {
          "status":"no_match"
        }
        respond_to do |format|
          format.json { render :json => json_data}
        end
      end
    end
  end
  def delete_order
    detail_id = params[:detail_id]
    # Get Order id from order detail_id
    order = Order.where(detail_id:detail_id).first
    order_id = order.id
    OrderDetail.find(detail_id).destroy
    OrderBroadcastJob.perform_later("remove",order)
    Order.find(order_id).destroy
    json_data = {"status":"ok"}
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def delete_orders id
    order = Order.find(id)
    detail_id = order.detail_id
    OrderDetail.find(detail_id).destroy
    OrderBroadcastJob.perform_later("remove",order)
    Order.find(id).destroy
  end
  def delete_my_order
    order_id = params[:order_id]
    # Get order from id
    order = Order.where(id:order_id).first
    if order.state == 1
      json_data = {"status":"fail"}
    else
      detail_id = order.detail_id
      OrderDetail.find(detail_id).destroy
      OrderBroadcastJob.perform_later("remove",order)
      Order.find(order_id).destroy
      json_data = {"status":"ok"}
    end
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def delete_my_orders
    account_address = params[:account_address]
    del_orders = Order.where(maker_address:account_address)
    flag = true;
    if del_orders.length > 0
      del_orders.each_with_index do |del_order, index|
        if del_order.state == 1
          flag = false
          continue
        end

        order_id = del_order.id
        # Get order and order detail
        detail_id = del_order.detail_id
        OrderDetail.find(detail_id).destroy
        OrderBroadcastJob.perform_later("remove",del_order)
        Order.find(order_id).destroy
      end
    end
    if flag == true
      json_data = {"status":"ok"}
    else
      json_data = {"status":"fail"}
    end

    respond_to do |format|
      format.json{ render :json => json_data }
    end

  end
  def update_order
    detail_id = params[:detail_id]
    amount = params[:amount]
    # logger.debug(amount)
    order = Order.where(detail_id:detail_id).first
    order.amount = amount
    order.save
    json_data = {"status":"update_order"}
    respond_to do |format|
      format.json{ render :json => json_data }
    end

  end
  def update_orders(id,amount)
    order = Order.where(id:id).first
    order.amount = amount
    order.save
  end
  def create_order
    signed_order = params[:signed_order]
    state = params[:state]
    type = params[:type]
    base_token = params[:base_token]
    token_symbol = params[:token_symbol]
    amount = params[:amount]
    token_price = params[:price]
    expire = params[:expire]
    expire_date = params[:expire_date]
    taker_amount = params[:taker_amount]
    maker_amount = params[:maker_amount]
    maker_address = params[:maker_addr]
    token_addr = params[:token_addr]
    trade_fee = params[:trade_fee]
    order_hash = params[:order_hash]

    set_allow = ''
    tx_hash = ''
    token_allow = getTokenAllowance token_addr
    if token_allow == 0
      set_allow = 'set_token_allow'
      tx_hash = setTokenAllowance token_addr
    else
      set_allow = 'not set_token_allow'
    end

    detail = OrderDetail.new
    detail.signedorder = signed_order
    detail.expire = expire_date
    detail.taker_amount = taker_amount
    detail.maker_amount = maker_amount
    detail.save
    detail_id = detail.id

    # Save Order to db
    order = Order.new
    order.type = type
    order.state = state
    order.base_token = base_token
    order.token_symbol = token_symbol
    order.amount = amount
    order.price = token_price
    order.order_hash = order_hash
    order.fee = trade_fee
    order.expire = expire
    order.detail_id = detail_id
    order.maker_address = maker_address
    order.save

    result = batchfillOrder(type.to_i,token_price.to_f,amount.to_f,base_token,token_symbol)

    json_data =
    {
      "status":"ok",
      "result":result,
      "token_allow":tx_hash
    }
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def get_tx
    userAddress = params[:address]
    pending_trades = PendingTrade.where("maker_address = ? OR taker_address = ?", userAddress, userAddress).order(created_at: :desc);
    json_data = {
      "status":"ok",
      "data":pending_trades
    }
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def remove_tx
    txHash = params[:txHash]
    json_data = {
      "status":"ok"
    }

    pending_trade = PendingTrade.where(txHash:txHash).first
    if pending_trade
      PendingTrade.find(pending_trade.id).destroy
    end

    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def create_trade_history
    symbol = params[:symbol]
    type = params[:type]
    maker_address = params[:maker_addr]
    taker_address = params[:taker_addr]
    price = params[:price]
    amount = params[:amount]
    base_token = params[:base_token]
    txHash = params[:txHash]

    # Save Data to TradeHistory table
    trade = TradeHistory.new
    trade.base_token = base_token
    trade.token_symbol = symbol
    trade.type = type
    trade.maker_address = maker_address
    trade.taker_address = taker_address
    trade.price = price
    trade.amount = amount
    trade.save

    json_data = {"status":"ok"}
    respond_to do |format|
      format.json{ render :json => json_data}
    end
  end
  def create_trade_histories(symbol,type,maker_address,taker_address,price,amount,base_token,txHash)
    # Save Data to TradeHistory table
    trade = TradeHistory.new
    trade.base_token = base_token
    trade.token_symbol = symbol
    trade.type = type
    trade.maker_address = maker_address
    trade.taker_address = taker_address
    trade.price = price
    trade.amount = amount
    trade.txHash = txHash
    trade.save
  end
  def get_trade_history
    symbol = params[:symbol]
    base_token = params[:base_token]
    trade_histories = TradeHistory.where(base_token:base_token,token_symbol:symbol).limit(100).order(updated_at: :desc)
    json_data = {
      "status":"ok",
      "data":trade_histories
    }
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def get_signed_order
    order_id = params[:address]
    signed_order = OrderDetail.where(id:order_id).order(updated_at: :desc)
    json_data = {
      "status":"ok",
      "data":signed_order,
      "id":order_id
    }
    respond_to do |format|
      format.json{ render :json => json_data }
    end
  end
  def show
  end
  def change_contract_address(address)
    changed_address = address.to_s[0,7] +"..." +address.to_s[-4..-1]
    return changed_address
  end
  def get_decimals_places(param)
    amount = BigDecimal.new(param.to_s)
    if amount.to_s.split(".")[1]
      length = amount.to_s.split(".")[1].size
    else
      length = 0
    end
    return length
  end
  def maker_zero(param)
    place = 8 - param
    zeros = ""
    for i in 0..place do
      zeros << "0"
    end
    return zeros
  end
  def amount_pro(amount, max)
    if max == nil
      return 16.667
    else
      return ((BigDecimal.new(amount.to_s) / BigDecimal.new(max.to_s))*16.667).truncate(4)
    end
  end
  def volume_pro(max, volume)
    return ((BigDecimal.new(volume.to_s) / BigDecimal.new(max.to_s)) * 66.667).truncate(4)
  end
  def get_timeformat(t)
    format = t.to_s.split(" ")
    day = format[0].split("-")
    time = format[1].split(":");
    time_format = day[1] + "-" + day[2] + " " + time[0] + ":" + time[1] + ":" + time[0]
    return time_format
  end
  # Reward system
  def reward

  end

  def get_reward
    user_wallet_address = params[:wallet_address]
    init_volume = 0;
    claimed = RewardManager.where("wallet_address = ?",user_wallet_address).order(created_at: :desc)
    if claimed.length > 0
      trades = TradeHistory.where("created_at > ? AND base_token = ? AND reward_status IS NULL AND (maker_address = ? OR taker_address = ?)",claimed[0].created_at,"WETH",user_wallet_address,user_wallet_address).order(created_at: :desc)
      # trades = TradeHistory.where("created_at > ? AND base_token = ? AND reward_status IS NULL AND taker_address = ?",claimed[0].created_at,"WETH",user_wallet_address).order(created_at: :desc)
    else
      init_volume = 1000;
      trades = TradeHistory.where("base_token = ? AND reward_status IS NULL AND (maker_address = ? OR taker_address = ?)","WETH",user_wallet_address,user_wallet_address).order(created_at: :desc)
      # trades = TradeHistory.where("base_token = ? AND reward_status IS NULL AND taker_address = ?","WETH",user_wallet_address).order(created_at: :desc)
    end
    total_volume = 0
    if trades
      trades.each_with_index do |trade, index|
        if trade.total_amount == nil || trade.total_amount == 0
          next
        end
        if trade.taker_total_amount == nil || trade.taker_total_amount == 0
          next
        end
        # volume = BigDecimal.new(trade.price.to_s) * BigDecimal.new(trade.amount.to_s)
        if trade.maker_address == user_wallet_address
          volume = BigDecimal.new(trade.amount.to_s) * 100.0 / BigDecimal.new(trade.total_amount.to_s)
        elsif trade.taker_address == user_wallet_address
          volume = BigDecimal.new(trade.amount.to_s) * 100.0 / BigDecimal.new(trade.taker_total_amount.to_s)
        end
        total_volume += BigDecimal.new(volume)
      end
      # volume = (total_volume * $reward_ratio).to_i
      volume = total_volume.to_i
    end
    json_data = {
      "state":"OK",
      "trades":trades,
      "volume":init_volume,
      "claimed":claimed
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end

  def request_reward
    wallet_addr = params[:wallet_addr]
    old_reward = Reward.where("wallet_address = ?",wallet_addr).order(created_at: :asc).last
    if old_reward
      trades = TradeHistory.where("base_token = ? AND created_at > ? AND reward_status IS NULL AND (maker_address = ? OR taker_address = ?)","WETH",old_reward.created_at,wallet_addr,wallet_addr).order(created_at: :asc)
    else
      trades = TradeHistory.where("base_token = ? AND reward_status IS NULL AND (maker_address = ? OR taker_address = ?)","WETH",wallet_addr,wallet_addr).order(created_at: :asc)
    end
    total_volume = 0
    if trades
      trades.each_with_index do |trade, index|
        volume = BigDecimal.new(trade.price.to_s) * BigDecimal.new(trade.amount.to_s)
        total_volume += BigDecimal.new(volume)
      end
      tm_point = (total_volume * $reward_ratio).to_f.truncate(2)
      if tm_point > $reward_request_amount
        amount = (tm_point - $reward_tm_fee) * 0.9
        reward_manager = RewardManager.where("wallet_address = ?",wallet_addr).first;
        if reward_manager
          if reward_manager.approved == false
            json_data = {
              "state": "fail",
              "tx": '',
              "tm_point": ''
            }
            respond_to do |format|
              format.json { render :json=>json_data}
            end
            return
          end
        else
          reward_manager = RewardManager.new
          reward_manager.wallet_address = wallet_addr
          reward_manager.save
        end

        tx = send_tm_token(amount,wallet_addr)

        create_reward(wallet_addr, amount,tx)

        current_user = User.where("wallet_address = ?",wallet_addr).first;
        if current_user
          recommended_user = User.where("referral_id = ?",current_user.recommended_id).first;
          if recommended_user
            referral_manager = ReferralManager.where("wallet_address = ?",recommended_user.wallet_address).first
            if !referral_manager
              referral_manager = ReferralManager.new
              referral_manager.wallet_address = recommended_user.wallet_address
              referral_manager.save
            elsif referral_manager.approved == false
              json_data = {
                "state": "recommend_fail",
                "tx": tx,
                "tm_point": amount
              }
              respond_to do |format|
                format.json { render :json=>json_data}
              end
              return
            end

            send_tm_token((tm_point - $reward_tm_fee) * 0.1, recommended_user.wallet_address)
          end
        end
        json_data = {
          "state": "ok",
          "tx": tx,
          "tm_point": amount
        }
      else
        json_data = {
          "state": "low_tm_point",
          "volume": total_volume
        }
      end
    else
      json_data = {
        "state": "No_transaction",
        "volume": total_volume
      }
    end
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end

  def create_reward(wallet_address, amount,txHash)
    # Save reward to db
    reward = Reward.new
    reward.wallet_address = wallet_address
    reward.amount = amount
    reward.txHash = txHash
    reward.save
  end

  # wallet account
  def account

  end

  # Referral system
  def referral

  end

  def get_referral
    user_wallet_address = params[:wallet_address]
    claimed = ReferralManager.where("wallet_address = ?",user_wallet_address).order(created_at: :desc)
    json_data = {
      "state":"OK",
      "claimed":claimed
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end

  # make referral id with wallet address
  def mk_referral_id(address)
    md5 = Digest::MD5.new.hexdigest address
    md5_str = md5.to_s
    referral_id = md5_str.to_s[0,5].to_s +  + md5_str.to_s[-4..-1].to_s
    # return sha2
    return referral_id
  end
  # Get eth_to_usd price from coinmarketcap API
  def get_eth_price
    url = URI.parse('https://api.coinmarketcap.com/v2/ticker/?limit=100 &start= 1& convert=ETH')
    url = URI.parse('https://api.coinmarketcap.com/v2/ticker/1027/?convert=USD')

    http = Net::HTTP.new(url.host,url.port)
    http.use_ssl = true
    resp = http.get(url)

    parsed = resp.body
    json_data = (JSON.parse parsed)["data"]


    eth_price = json_data["quotes"]["USD"]["price"]
    return eth_price
  end

  def get_eth_usd_price
    url = URI.parse('https://api.coinmarketcap.com/v2/ticker/?limit=100 &start= 1& convert=ETH')
    url = URI.parse('https://api.coinmarketcap.com/v2/ticker/1027/?convert=USD')

    http = Net::HTTP.new(url.host,url.port)
    http.use_ssl = true
    resp = http.get(url)

    parsed = resp.body
    json_data = (JSON.parse parsed)["data"]


    eth_price = json_data["quotes"]["USD"]["price"]
    json_data = {
      "price": eth_price
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end

  def get_sort_token_list
    type = params[:type]
    dir = params[:dir]
    tokens = Token.where("symbol != ?","WETH").order(name: :asc)
    json_data = {
      "state": "ok",
      "tokens":tokens
    }
    respond_to do |format|
      format.json { render :json=>json_data}
    end
  end

  # Download whitepaper
  def download_whitepaper
    if params[:lang] == 'eng'
      send_file(
          "#{Rails.root}/public/whitepaper_eng_1.1.pdf",
          filename: 'Whitepaper(eng).pdf',
          type: 'application/pdf'
      )
    else
      send_file(
          "#{Rails.root}/public/whitepaper_kor_1.1.pdf",
          filename: 'Whitepaper(kor).pdf',
          type: 'application/pdf'
      )
    end
  end

  def terms
    send_file(
        "#{Rails.root}/public/terms.pdf",
        filename: 'Tokenmom.com\'s Terms and Conditions.pdf',
        type: 'application/pdf'
    )
  end

  def privacy
    send_file(
        "#{Rails.root}/public/privacy.pdf",
        filename: 'Tokenmom.com\'s Privacy Policy.pdf',
        type: 'application/pdf'
    )
  end
end
