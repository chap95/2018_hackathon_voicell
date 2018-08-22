class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :user_nickname
      t.string :thumnail_image
      t.string :voice_uploade_file
      t.integer :price #가격
      t.timestamp :left_time #시간
      t.integer :user_id #게시글 작성자 정보(유저 번호)

      t.timestamps
    end
  end
end
