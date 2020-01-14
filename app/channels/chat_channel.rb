class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
  end

  def send_message(data)
    
    messages = Message.where(room_id: data['room_id']).order(created_at: :asc)
    logger.debug(messages.length)
    if messages.length > 100
      for message in messages[0..messages.length-100] do
        message.destroy
      end
    end
    # json_data = Array.new
    # messages.each_with_index do |message, index|
    #   json_record = {
    #       :content => message.content,
    #       :nick_name => message.user.nick_name,
    #       :contract_address => message.user.wallet_address
    #   }
    #   json_data.push json_record
    # end
    # respond_to do |format|
    #   format.json { render :json=>json_data}
    # end
    Message.create(content: data['message'],room_id: data['room_id'], user_id: data['user_id'])
  end
end