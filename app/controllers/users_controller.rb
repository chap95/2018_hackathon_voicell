class UsersController < ApplicationController
    # 로그인 된 사용자만 접근 가능
    before_action :authenticate_user!
    # Rolify + Cancancan
    load_and_authorize_resource
    
    def page 
        @posts = Post.all.page(params[:page]).per(10)
        @comments = Comment.all.page(params[:page]).per(10)
        
        @user = User.find(params[:id])
        # 권한을 가진 자만 접근가능! / 해당 def만 rolife+cancancan 적용.
        #authorize! :show, @user
    end
end
