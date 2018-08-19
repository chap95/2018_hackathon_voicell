class Image < ApplicationRecord
    mount_uploader :file, ImageUploader
    #belongs_to :bulletin
    
    # 이미지를 가진 게시글 삭제 시 AWS S3서버에도 자동 삭제처리
    before_destroy :destroy_assets
 
    def destroy_assets
        self.file.remove! if self.file
        self.save!
    end
end