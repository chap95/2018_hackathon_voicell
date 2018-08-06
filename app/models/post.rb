class Post < ApplicationRecord
    mount_uploader :voice_uploade_file, VoiceFileUploader
    
    belongs_to :bulletin
    belongs_to :user
    
    #게시글이 삭제되도 DB에는 원본 기록이 남아있음.
    acts_as_paranoid
    
    #대댓글 지원
    acts_as_commentable
    
    # 게시글 및 댓글 제목, 내용을 다 썼는지 체크
    validates :title, :content, presence: true
end
