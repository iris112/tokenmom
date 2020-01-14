jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $new_message_form = $('#new-message')
  $new_message_body = $('#message_body')
  $language = $('.language')
  $language_menu = $('.dropdown-language-menu')
  $('.dropdown-language-menu').on 'click', 'li', (event) ->
    if $('#trade_workspace').length
      selText = $(this).text()
      value = $(this).val()
      getMessages(value)
  $(".dropdown-menu.language").on 'click', 'li', (event) ->
    if $('#trade_workspace').length
      value = $(this).val()
      getMessages(value)
  $($language).change ->
    if $('#trade_workspace').length
      value = $('.language option:selected').val()
      getMessages(value)
  if $('#trade_workspace').length
    getMessages() 
  else
  if $messages.length > 0
    App.chat = App.cable.subscriptions.create {
      channel: "ChatChannel"
      },
      connected: ->

      disconnected: ->

      received: (data) ->
        value = $(".dropdown-toggle.language-link").val() || 1
        int_value = parseInt(value)
        if int_value == data['room_id']
          if data['message']
            # $new_message_body.val('')
            $messages.append data['message']
            messages = $('#messages')
            $messages.scrollTop(messages.prop("scrollHeight"))
      send_message: (message) ->
        value = $(".dropdown-toggle.language-link").val() || 1
        user_id = $('#message_body').attr('data-user-id')
        @perform 'send_message', message: message,room_id: value, user_id: user_id

      $new_message_body.on 'keyup', (e) ->
        
        $this = $(this)
        $language = $('.language option:selected').val()
        message_body = $new_message_body.val()
        
        if e.keyCode == 13 && $.trim(message_body).length > 0 && $.trim(message_body).length < 100
          App.chat.send_message message_body
          $new_message_body.val('')
        e.preventDefault()
        return false
drawMessages = (data)->
  $messages = $('#messages')
  $messages.html('')  
  $.each data, (index, element) ->
    $messages.append  '<div class="message">'+'<strong><a href="' + http_link + 'address/' + element.contract_address + '" rel="noopener noreferrer" target="_blank">' + element.nick_name + ' :</a></strong> ' + element.content + '<br>' + '</div>'
  
  messages = $('#messages')
  $messages.scrollTop(messages.prop("scrollHeight"))
  
getMessages = (param1) ->
  param1 = param1 || 1
  $.ajax
    url: 'get_messages'
    type: 'POST'
    dataType: 'json'
    data:
      param1: param1
    success: (data) ->
      drawMessages data
    error: (data) ->
      console.log('error')
