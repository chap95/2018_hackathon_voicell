class Post < ApplicationRecord
    belongs_to :bulletin
    belongs_to :user
    
    #게시글이 삭제되도 DB에는 원본 기록이 남아있음.
    acts_as_paranoid
end
