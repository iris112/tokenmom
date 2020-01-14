require 'net/http'
require 'net/https'
require 'uri'
require 'json'

module API
  module V1
    class Datafeeds < Grape::API
      include API::V1::Defaults

      # datafeed endpoint
      resource :datafeeds do
        desc "Nothing to do"
        get root: :datafeeds do
          "Data feeds"
        end

        # GET /time
        resource :time do
          get root: :time do
            render Time.now.to_i
          end
        end
        # symbol group request
        resource :symbol_info do
          get root: :symbol_info do
          end
        end

        # symbol resolve
        resource :symbols do
          get root: :symbols do
            symbol = params[:symbol]
            # token_symbol = symbol.split("-")[0]
            # base_token = symbol.split("-")[1]
            render :name => symbol,
                   :ticker => symbol,
                   :description => symbol,
                   :type => "bitcoin",
                   :exchange => "TokenMom",
                   :minmov => 1,
                   :pricescale => 10000000000,
                   :minmove2 => 0,
                   :timezone => "Etc/UTC",
                   :has_intraday => true,   
                   :has_seconds => true,                
                   :supported_resolutions => ['3','15', '30', '60', '1D']               
                                                  
          end
          params do
            requires :symbol, type: String, desc: "Token symbol"
          end
        end

        # config
        resource :config do
          get root: :config do
            render :supports_group_request => false,
                   :supports_marks => false,
                   :supports_search => true,   
                   :supported_resolutions => ['3','15', '30', '60', '1D'],                   
                   :supports_timescale_marks => false,               
                   :exchanges => ["ERC", "TM"],
                   :supports_time => true
          end
        end

        # datafeed/history, Get Bars
        resource :history do
          get root: :history do
            if params[:symbol] && params[:resolution] && params[:from] && params[:to]
              t = Array.new
              c = Array.new
              o = Array.new
              h = Array.new
              l = Array.new
              v = Array.new   

              symbol = params[:symbol]
              token_symbol = symbol.split("-")[0]
              base_token = symbol.split("-")[1]

              if params[:resolution] == "1D"
                distance = params[:to].to_i - params[:from].to_i
                count = distance / 86400
                for i in 0..count
                  from_stamp = params[:from].to_i + i * 86400
                  to_stamp = from_stamp + 86400
                  from = DateTime.strptime(from_stamp.to_s,'%s')
                  to = DateTime.strptime(to_stamp.to_s,'%s')
                  open = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).first
                  if open
                    close = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).last
                    high = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).maximum("price")
                    low = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).minimum("price")
                    amounts = TradeHistory.select("amount").where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token)
                    volume = 0.00
                    for amount in amounts                    
                      volume += amount.amount.to_f
                    end
                    t << open.created_at.to_i
                    c << close.price.to_f
                    o << open.price.to_f
                    h << high.to_f
                    l << low.to_f
                    v << volume.to_f
                  end
                end
                if t.length > 0
                  render :s => "ok",
                         :t => t,
                         :c => c,
                         :o => o,
                         :h => h,
                         :l => l,
                         :v => v
                else
                  render :s => "no_data"
                end 
              elsif params[:resolution] == "3"
                distance = params[:to].to_i - params[:from].to_i
                count = distance / 180
                for i in 0..count
                  from_stamp = params[:from].to_i + i * 180
                  to_stamp = from_stamp + 180
                  from = DateTime.strptime(from_stamp.to_s,'%s')
                  to = DateTime.strptime(to_stamp.to_s,'%s')
                  open = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).first
                  if open
                    close = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).last
                    high = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).maximum("price")
                    low = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).minimum("price")
                    amounts = TradeHistory.select("amount").where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token)
                    volume = 0.00
                    for amount in amounts                    
                      volume += amount.amount.to_f
                    end
                    t << open.created_at.to_i
                    c << close.price.to_f
                    o << open.price.to_f
                    h << high.to_f
                    l << low.to_f
                    v << volume.to_f
                  end
                end
                if t.length > 0
                  render :s => "ok",
                         :t => t,
                         :c => c,
                         :o => o,
                         :h => h,
                         :l => l,
                         :v => v
                else
                  render :s => "no_data"
                end  
              elsif params[:resolution] == "15"
                distance = params[:to].to_i - params[:from].to_i
                count = distance / 900
                for i in 0..count
                  from_stamp = params[:from].to_i + i * 900
                  to_stamp = from_stamp + 900
                  from = DateTime.strptime(from_stamp.to_s,'%s')
                  to = DateTime.strptime(to_stamp.to_s,'%s')
                  open = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).first
                  if open
                    close = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).last
                    high = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).maximum("price")
                    low = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).minimum("price")
                    amounts = TradeHistory.select("amount").where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token)
                    volume = 0.00
                    for amount in amounts                    
                      volume += amount.amount.to_f
                    end
                    t << open.created_at.to_i
                    c << close.price.to_f
                    o << open.price.to_f
                    h << high.to_f
                    l << low.to_f
                    v << volume.to_f
                  end
                end
                if t.length > 0
                  render :s => "ok",
                         :t => t,
                         :c => c,
                         :o => o,
                         :h => h,
                         :l => l,
                         :v => v
                else
                  render :s => "no_data"
                end
                
              elsif params[:resolution] == "30"
                distance = params[:to].to_i - params[:from].to_i
                count = distance / 1800
                for i in 0..count
                  from_stamp = params[:from].to_i + i * 1800
                  to_stamp = from_stamp + 1800
                  from = DateTime.strptime(from_stamp.to_s,'%s')
                  to = DateTime.strptime(to_stamp.to_s,'%s')
                  open = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).first
                  if open
                    close = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).last
                    high = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).maximum("price")
                    low = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).minimum("price")
                    amounts = TradeHistory.select("amount").where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token)
                    volume = 0.00
                    for amount in amounts                    
                      volume += amount.amount.to_f
                    end
                    t << open.created_at.to_i
                    c << close.price.to_f
                    o << open.price.to_f
                    h << high.to_f
                    l << low.to_f
                    v << volume.to_f
                  end
                end
                if t.length > 0
                  render :s => "ok",
                         :t => t,
                         :c => c,
                         :o => o,
                         :h => h,
                         :l => l,
                         :v => v
                else
                  render :s => "no_data"
                end
              elsif params[:resolution] == "60"
                distance = params[:to].to_i - params[:from].to_i
                count = distance / 3600
                for i in 0..count
                  from_stamp = params[:from].to_i + i * 3600
                  to_stamp = from_stamp + 3600
                  from = DateTime.strptime(from_stamp.to_s,'%s')
                  to = DateTime.strptime(to_stamp.to_s,'%s')
                  open = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).first
                  if open
                    close = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).order(created_at: :asc).last
                    high = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).maximum("price")
                    low = TradeHistory.where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token).minimum("price")
                    amounts = TradeHistory.select("amount").where("created_at > ? AND created_at < ? AND token_symbol = ? AND base_token = ?", from,to,token_symbol,base_token)
                    volume = 0.00
                    for amount in amounts                    
                      volume += amount.amount.to_f
                    end
                    t << open.created_at.to_i
                    c << close.price.to_f
                    o << open.price.to_f
                    h << high.to_f
                    l << low.to_f
                    v << volume.to_f
                  end
                end
                if t.length > 0
                  render :s => "ok",
                         :t => t,
                         :c => c,
                         :o => o,
                         :h => h,
                         :l => l,
                         :v => v
                else
                  render :s => "no_data"
                end
              end          
            else
              render :s => "error",
                     :errmsg => "Invalid parameters in getting bars"
            end
          end
          params do
            requires :symbol, type: String, desc: "Token symbol"
            requires :resolution, type: String, desc: "Interval"
            requires :from, type: String, desc: "from value of period"
            requires :to, type: String, desc: "to value of period"
          end
        end

        # datafeed/quotes
        resource :quotes do
          get root: :quotes do
            "Quotes"
          end
        end

        # datafeed/iquotes
        resource :iquotes do
          get root: :iquotes do
            "iQuotes"
          end
        end

        # datafeed/data_pulse
        resource :data_pulse do
          get root: :data_pulse do
            "Data Pulse"
          end
        end
      end
    end
  end
end
