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
    
    respond_to do |format|
      if @comment.save
        make_child_comment
        format.html  { redirect_to(request.referrer, :notice => '댓글이 작성되었습니다.') }
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