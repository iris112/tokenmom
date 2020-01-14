jQuery(document).on 'turbolinks:load', ->
    App.order = App.cable.subscriptions.create {
        channel:"TradeChannel"
        },
        connected: ->

        disconnected: ->

        received: (data) ->
            trade = data.trade
            TxWatch.addTx(trade);

            symbol = $(".token-info").attr("token_symbol") || "ZRX"
            base_token = $(".token-info").attr("base_token") || "ETH"
            # Trade.get_tokens_table()
            if symbol == trade.token_symbol and base_token == trade.base_token
                draw_trade trade
                Trade.get_tokens_table()
                $.ajax
                    url: 'get_tokens'
                    type: 'POST'
                    dataType: 'json'
                    data:
                        base_token: base_token
                        symbol: symbol
                    success: (data) ->
                    #   Trade.change_token_list(data.tokens,symbol,base_token)
                    #   Trade.draw_market_table(data.tokens);
                    error: (data) ->
                      console.log('error')
                # change_header_info trade.token_symbol
                if currentWalletAddress ==  trade.maker_address or currentWalletAddress == trade.taker_address
                    Trade.trade_alert()
            else if symbol != trade.token_symbol and base_token == trade.base_token
                # Trade.change_token_list(trade.token_symbol,trade.base_token)
                $.ajax
                    url: 'get_tokens'
                    type: 'POST'
                    dataType: 'json'
                    data:
                        base_token: base_token
                        symbol: symbol
                    success: (data) ->
                    #   Trade.change_token_list(data.tokens,symbol,base_token)
                      Trade.draw_market_table(data.tokens);
                    error: (data) ->
                      console.log('error')

            else
        create_trade: (data) ->
draw_trade = (trade) ->
    tag = $('#trade_history_all table tbody')
    my_tag = $("#trade_history_me table tbody")
    time = trade.created_at
    price = trade.price
    amount = trade.amount
    type = trade.type

    price = trade.price
    price_places = Trade.decimalPlaces(price)
    price_rest_places = 8 - price_places
    price_zero_places = ''
    i = 0
    while i < price_rest_places
      price_zero_places += '0'
      i++
    if price_places == 0
      price = parseInt(price).toString() + '.'
    else
      price = parseFloat(price).toString()

    time_format = get_timeformat(time)
    trades =
        '<tr class = \'cover-row\'>' +
            '<td>' +
                '<strong class = \'number\'>' + time_format + '</strong>' +
            '</td>'
    if type == 1
        trades +=
        '<td class = \'text-right text-success\'>' +
            '<strong class = \'number\'>' + price +
                '<span class=\'p3 opacity-color\'>' + price_zero_places + '</span>' +
            '</strong>' +
            '<i aira-hidden = \'true\' class = \'fa fa-caret-up\'>' + '</i>' +
        '</td>'
    else if type == 0
        trades +=
        '<td class = \'text-right text-danger\'>' +
            '<strong class = \'number\'>' + price +
                '<span class=\'p3 opacity-color\'>' + price_zero_places + '</span>' +
            '</strong>' +
            '<i aira-hidden = \'true\' class = \'fa fa-caret-down\'>' + '</i>' +
        '</td>'
    trades +=
    '<td class = \'text-right\'>' +
        '<strong class=\'number\'>' + amount + '</strong>' +
    '</td>' +
    '</tr>'
    tag.prepend trades

    if currentWalletAddress
        if currentWalletAddress == trade.maker_address or currentWalletAddress == trade.taker_address

            price = trade.price

            price_places = Trade.decimalPlaces(price)
            price_rest_places = 8 - price_places
            price_zero_places = ''
            i = 0
            while i < price_rest_places
              price_zero_places += '0'
              i++
            if price_places == 0
              price = parseInt(price).toString() + '.'
            else
              price = parseFloat(price).toString()
            my_trade =
            "<tr class = \'cover-row\'>"
            my_trade +=
                '<td class=\'text-left\'>' +
                    '<a target=\'_blank\' rel=\'noopener noreferrer\' href=\''+http_link+'tx/' + trade.txHash + '\'>' +
                        '<i class=\'fa fa-link\' aria-hidden=\'true\'>' +
                    '</a>' +
                '</td>'
            if type == 1
              if currentWalletAddress == trade.maker_address
                my_trade += '<td class = \'text-success\'>' + '<span class = \'number\'>' + 'Buy' + '</span>' + '</td>'
              else if currentWalletAddress == trade.taker_address
                my_trade += '<td class = \'text-danger\'>' + '<span class = \'number\'>' + 'Sell' + '</span>' + '</td>'
            else if type == 0
              if currentWalletAddress == trade.maker_address
                my_trade += '<td class = \'text-danger\'>' + '<span class = \'number\'>' + 'Sell' + '</span>' + '</td>'
              else if currentWalletAddress == trade.taker_address
                my_trade += '<td class = \'text-success\'>' + '<span class = \'number\'>' + 'Buy' + '</span>' + '</td>'

            my_trade +=
                '<td>' +
                    '<strong class = \'number\'>' + time_format + '</strong>' +
                '</td>'
            if type == 1
                my_trade +=
                '<td class = \'text-right text-success\'>' +
                    '<strong class = \'number\'>' + price +
                        '<span class=\'p3 opacity-color\'>' + price_zero_places + '</span>' +
                    '</strong>' +

                '</td>'
            else if type == 0
                my_trade +=
                '<td class = \'text-right text-danger\'>' +
                    '<strong class = \'number\'>' + price +
                        '<span class=\'p3 opacity-color\'>' + price_zero_places + '</span>' +
                    '</strong>' +

                '</td>'
            my_trade +=
            '<td class = \'text-right\'>' +
                '<strong class=\'number\'>' + amount + '</strong>' +
            '</td>' +
            '</tr>'
            my_tag.prepend my_trade
        else
    else

    return;
get_timeformat = (t) ->
    time_format = ''
    format = t.split('T')
    day = format[0].split('-')
    time = format[1].split('.')[0].split(':')
    time_format += day[1] + '-' + day[2] + ' ' + time[0] + ':' + time[1] + ':' + time[2]
    time_format
change_header_info = (symbol) ->
    symbol = symbol
    base_token = $('.token-header').children('li').children('div').attr 'base_token'
    token_contract = $(".contract-address").children('a').attr('value');
    $.ajax
        url: 'get_token_info'
        type: 'POST'
        dataType: 'json'
        data:
            base_token: base_token
            symbol: symbol
            token_contract:token_contract
        success: (data) ->
          Trade.change_header_info data.token_info
        error: (data) ->
          console.log('error')
