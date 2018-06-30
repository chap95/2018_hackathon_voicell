class PostsController < ApplicationController
  # 로그인 된 사용자만 접근 가능
  before_action :authenticate_user!
    
  load_and_authorize_resource
  before_action :set_bulletin
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = @bulletin.present? ? @bulletin.posts.all : Post.all
  end

  def show
  end

  def new
    @post = @bulletin.present? ? @bulletin.posts.new : Post.new
  end

  def edit
  end

  def create
    @post = @bulletin.present? ? @bulletin.posts.new(post_params) : Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to (@bulletin.present? ? [@post.bulletin, @post] : @post), notice: '게시글이 작성되었습니다.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to (@bulletin.present? ? [@post.bulletin, @post] : @post), notice: '게시글이 수정되었습니다.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to (@bulletin.present? ? bulletin_posts_url : posts_url), alert: '게시글이 삭제되었습니다.' }
      format.json { head :no_content }
    end
  end

  private
  def set_bulletin
    @bulletin = Bulletin.find(params[:bulletin_id]) if params[:bulletin_id].present?
  end

  def set_post
    if @bulletin.present?
      @post = @bulletin.posts.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end

  def post_params
    params[:post][:user_id] = current_user.id
    params.require(:post).permit(:title, :content, :user_id)
  end
end