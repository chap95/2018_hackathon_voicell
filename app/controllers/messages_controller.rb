class MessagesController < ApplicationController
    def create
        @conversation = Conversation.includes(:recipient).find(params[:conversation_id])
        @message = @conversation.messages.create(message_params)
        if Message.create
        if @message.user.nickname == @conversation.recipient.nickname
            @new_notification = NewNotification.create! user: Conversation.find(params[:conversation_id]).sender,
            content: "#{current_user.nickname.truncate(15, omission: '...')} 님으로 부터 쪽지가 왔습니다.",
            link: request.referrer
                                                   
        elsif @message.user.nickname == @conversation.sender.nickname
            @new_notification = NewNotification.create! user: Conversation.find(params[:conversation_id]).recipient,
            content: "#{current_user.nickname.truncate(15, omission: '...')} 님으로 부터 쪽지가 왔습니다.",
            link: request.referrer
        end
    end
        
        respond_to do |format|
            format.js
        end
    end
    
    private
    
    def message_params
        params.require(:message).permit(:user_id, :body)
    end
end
