class CreateBulletins < ActiveRecord::Migration[5.1]
  def change
    create_table :bulletins do |t|
      t.string :title
      t.text :content
      t.string :user_nickname
      t.boolean :opt_admin_only, default: 'false'
      t.boolean :board_mp3_upload_permit, default: 'false' #게시글 mp3파일 업로드 허용
      t.boolean :reply_mp3_upload_permit, default: 'false' #댓글 mp3파일 업로드 허용
      t.integer :user_id #게시글 작성자 정보(유저 번호)

      t.timestamps
    end
  end
end
