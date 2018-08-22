class PostsController < ApplicationController
  # 로그인 된 사용자만 접근 가능
  before_action :authenticate_user!, only: [:index, :new, :show, :edit]
  #skip_before_action :authenticate_user!, only: [:index]
  
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_bulletin
  
  # 권한설정
  load_and_authorize_resource

  def index
    @posts = Post.where(bulletin_id: @bulletin).order("created_at DESC").page(params[:page]).per(9)
    @posts_deleted = Post.with_deleted.where(bulletin_id: @bulletin).order("created_at DESC").page(params[:page]).per(9)
  end

  def show
    if current_user.has_role? :admin
      @post = Post.with_deleted.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
    @new_comment  = Comment.build_from(@post, current_user.id, "")
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
    if @post.deleted? == true
      @post.really_destroy!
      
      redirect_to bulletin_posts_path(@post.bulletin.id)
    else
      @post.destroy
      
      respond_to do |format|
        format.html { redirect_to bulletin_posts_path(@post.bulletin.id), notice: '게시글이 성공적으로 제거되었습니다.' }
        format.json { head :no_content }
      end
    end
  end
  
  def restore
    @post = Post.with_deleted.find(params[:post_id])
    @post.restore
    
    redirect_to bulletin_posts_path(@post.bulletin.id), notice: '게시글이 성공적으로 복구되었습니다.'
  end

  private
  def set_bulletin
    @bulletin = Bulletin.find(params[:bulletin_id]) if params[:bulletin_id].present?
  end

  def set_post
    if @bulletin.present?
      @post = @bulletin.posts.find(params[:id])
    else
      if current_user.has_role? :admin
        @post = Post.with_deleted.find(params[:id])
      else
        @post = Post.find(params[:id])
      end
    end
  end

  def post_params
    # 게시글 작성 시 자동적으로 유저 id랑 닉네임이 입력되게 함.
    params[:post][:user_id] = current_user.id
    params[:post][:user_nickname] = current_user.nickname
    # DB에 새 Attribute를 추가하더라도, 아랫 줄에 허용을 안해주면 내용 update가 안됨.
    params.require(:post).permit(:title, :content, :user_id, :user_nickname, :voice_uploade_file, :price, :left_time, :thumnail_image)
  end
end