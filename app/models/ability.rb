class Ability
  include CanCan::Ability

  def initialize(user)
    
    #user -> current_user 
    user ||= User.new # guest user (not logged in)
    
    if user.has_role? :admin #어드민 권한
    	can :manage, :all #create, edit
    
    elsif user.has_role? :normal
      #일반 회원 : 허용 목록
      can [:index, :show], AllNotice
      can [:page], User, id: user.id
      can [:index, :show, :new, :create], Post
      can [:edit, :update, :destroy], Post, user_id: user.id
      can [:create], Comment
      can [:edit, :update, :destroy], Comment, user_id: user.id
      
      #일반 회원 : 비허용 목록
      cannot [:index, :show, :new, :create, :edit, :update, :destroy], Bulletin, user_id: user.id
      cannot [:new, :create, :edit, :update, :destroy], AllNotice, user_id: user.id
    
    elsif user.has_role? :block_yellow
      #경고회원(Yellow) 회원 : 허용 목록
      can [:index, :show], AllNotice
      can [:page], User, id: user.id
      can [:index, :show], Post
      can [:edit, :update, :destroy], Comment, user_id: user.id
      
      #경고회원(Yellow) 회원 : 비허용 목록
      cannot [:new, :create], Post
      cannot [:edit, :update, :destroy], Post, user_id: user.id
      cannot [:index, :show, :new, :create, :edit, :update, :destroy], Bulletin, user_id: user.id
      cannot [:new, :create, :edit, :update, :destroy], AllNotice, user_id: user.id
      cannot [:create], Comment
      
    elsif user.has_role? :block_red
      can [:page], User, id: user.id
      can [:index, :show], AllNotice
      
      #경고회원(RED) 회원 : 비허용 목록
      cannot [:new, :create, :index, :show], Post
      cannot [:edit, :update, :destroy], Post, user_id: user.id
      cannot [:index, :show, :new, :create, :edit, :update, :destroy], Bulletin, user_id: user.id
      cannot [:new, :create, :edit, :update, :destroy], AllNotice, user_id: user.id
      cannot [:create], Comment
      cannot [:edit, :update, :destroy], Comment, user_id: user.id
      
    else
      can [:index, :show], AllNotice
      cannot [:index, :show, :new, :create], Bulletin
      cannot [:index, :show], Post
      cannot [:new, :create, :edit, :update, :destroy], AllNotice, user_id: user.id
      cannot [:create, :edit, :update, :destroy], Comment, user_id: user.id
    end
  end
end
