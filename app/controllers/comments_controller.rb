class CommentsController < ApplicationController
  before_action :authenticate_user!
 
  def create
    commentable = commentable_type.constantize.find(commentable_id)
    @comment = Comment.build_from(commentable, current_user.id, body)
    @comment.nickname = current_user.nickname
    @comment.voice_uploade_file_reply = params[:comment][:voice_uploade_file_reply]
    if commentable_type == "Post" #Post 모델에서만 Bulletin ID가 기록되게 함.
      @comment.bulletin_id = commentable.bulletin_id
    end
    
    if (commentable_type != "AllNotice")
      # TODO : Post 게시물 내에 댓글이 달릴 시 알림이 울림.
      @new_notification = NewNotification.create! user: commentable.user,
                                                        content: "#{current_user.nickname.truncate(15, omission: '...')} 님이 댓글을 달았습니다.",
                                                        link: request.referrer
    end
    
    respond_to do |format|
      if @comment.save
        make_child_comment
        format.html  { redirect_to(request.referrer, :notice => '댓글이 작성되었습니다.') }
        # [TODO] 댓글에 대댓글이 달릴 시 알림메세지 발생
        if @comment.parent != nil
            @new_notification2 = NewNotification.create!  user: @comment.parent.user,
                                                          content: "#{current_user.nickname.truncate(15, omission: '...')} 님이 답댓글을 달았습니다.",
                                                          link: request.referrer
        end
      else
        format.html  { redirect_to(request.referrer, :alert => '댓글 내용을 작성해주세요.') }
      end
    end
  end
 
  def destroy
      @comment = Comment.find_by(id: params[:id])
      @comment.delete
      respond_to do |format|
        format.html { redirect_to(request.referrer, :notice => '댓글이 삭제되었습니다.')}
        format.js
      end
  end
  
  #추천수 기능
  def upvote
    @comment = Comment.find(params[:id])
    
    if((current_user.voted_up_on? @comment) == true)
      @comment.unliked_by current_user
      redirect_to(request.referrer, :notice => "이 댓글의 추천을 취소하셨습니다.")
    else
      @comment.upvote_by current_user
      redirect_to(request.referrer, :notice => "이 댓글을 추천하셨습니다.")
    end
  end
 
  private
 
  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :comment_id, :user_id, :nickname, :bulletin_id, :voice_uploade_file_reply)
  end
 
  def commentable_type
    comment_params[:commentable_type]
  end
 
  def commentable_id
    comment_params[:commentable_id]
  end
 
  def comment_id
    comment_params[:comment_id]
  end
 
  def body
    comment_params[:body]
    session[:conversations] ||= []
  end
  
  def voice_uploade_file_reply
    comment_params[:voice_uploade_file_reply]
  end
 
  def make_child_comment
    return "" if comment_id.blank?
 
    parent_comment = Comment.find comment_id
    @comment.move_to_child_of(parent_comment)
  end
end