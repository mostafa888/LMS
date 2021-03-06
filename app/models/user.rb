class User < ActiveRecord::Base
	mount_uploader :avatar, AvatarUploader
	acts_as_followable
	acts_as_follower
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :owned_courses , class_name: 'Course', foreign_key: 'owner_id'
  has_many :posts , class_name: 'Post'
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :courses
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

end
