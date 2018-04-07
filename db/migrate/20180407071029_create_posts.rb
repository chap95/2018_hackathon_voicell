class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :user_id #게시글 작성자 정보(유저 번호)

      t.timestamps
    end
  end
end
