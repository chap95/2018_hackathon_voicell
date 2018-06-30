class User < ApplicationRecord
  has_many :posts
  has_many :bulletins
  
  #유저의 기본 권한 설정
  after_create :assign_default_role
  
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  def assign_default_role
    add_role(:normal)
  end
end
