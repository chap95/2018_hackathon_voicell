class Comment < ApplicationRecord
  belongs_to :bulletin
  
  mount_uploader :voice_uploade_file_reply, VoiceFileUploader
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]
  
  #추천수
  acts_as_votable
  
  #삭제기록 로그처리
  acts_as_paranoid
  
  #이미지 자동 삭제처리
  before_destroy :destroy_assets

  def destroy_assets
    self.voice_uploade_file_reply.remove! if self.voice_uploade_file_reply
    self.save!
  end

  validates :body, :presence => true
  validates :user, :presence => true
  validates :nickname, :presence => true

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_votable

  belongs_to :commentable, :polymorphic => true

  # NOTE: Comments belong to a user
  belongs_to :user

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    new \
      :commentable => obj,
      :body        => comment,
      :user_id     => user_id
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.any?
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
end
