class CreateBulletins < ActiveRecord::Migration[5.1]
  def change
    create_table :bulletins do |t|
      t.string :title
      t.text :content
      t.string :user_nickname
      t.boolean :opt_admin_only, default: 'false'
      t.boolean :mp3_upload_permit, default: 'false'
      t.integer :user_id #게시글 작성자 정보(유저 번호)

      t.timestamps
    end
  end
end
