class UsersController < ApplicationController
    def page
        @user = User.find(params[:id])
        # 권한을 가진 자만 접근가능! / 해당 def만 rolife+cancancan 적용.
        #authorize! :show, @user
    end
end
