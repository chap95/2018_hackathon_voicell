class HomesController < ApplicationController
  def index
  end
  
  def messages_box
    session[:conversations] ||= []
    
    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:recipient, :messages)
                                  .find(session[:conversations])
                                  
    @user = params[:user]
    
    # if @user != nil?
    #   redirect_to conversations_path(user_id: @user)
    # end
  end
end
