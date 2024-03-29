class User < ApplicationRecord
  has_many :posts
  has_many :bulletins
  has_many :all_notices
  has_many :comments
  
  # 알림
  acts_as_reader
  has_many :new_notifications
  
  # 프로필 이미지 업로드 (3MB 용량 제한)
  mount_uploader :profile_picture, ProfileUploader
  
  # 투표자(추천)
  acts_as_voter
  
  # 유저의 기본 권한 설정
  after_create :assign_default_role
  
  # 닉네임 중복 검사
  validates_uniqueness_of :nickname
  # 닉네임 길이 제한
  validates :nickname, :length => { :maximum => 15 }
  
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validate :password_complexity
  
  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,}$/
  
    #TODO 존댓말로 바꿔야댐.
    errors.add :password, '비밀번호는 최소 8자이상! *적어도 문자, 숫자, 특수문자 하나씩은 포함*'
  end
  
  def assign_default_role
    add_role(:normal)
  end
end
