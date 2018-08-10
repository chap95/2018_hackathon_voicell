class ActsAsCommentableWithThreadingMigration < ActiveRecord::Migration[5.1]
  def self.up
    create_table :comments do |t|
      t.string :nickname
      t.integer :bulletin_id # 게시판 카테고리 번호
      t.string :voice_uploade_file_reply # 음원파일 업로드
      t.integer :commentable_id
      t.string :commentable_type
      t.string :title
      t.text :body
      t.string :subject
      t.integer :user_id, :null => false
      t.integer :parent_id, :lft, :rgt
      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :voice_uploade_file_reply # 음원파일 업로드
  end

  def self.down
    drop_table :comments
  end
end
