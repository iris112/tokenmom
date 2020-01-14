jQuery(document).on 'turbolinks:load', ->
    App.order = App.cable.subscriptions.create {
        channel:"RewardChannel"
        },
        connected: ->

        disconnected: ->

        received: (data) ->
            reward_update_addr = data.reward
            if reward_update_addr == currentWalletAddress.toLowerCase()
                console.log(currentWalletAddress)
                draw_claimed_tables(currentWalletAddress)
