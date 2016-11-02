class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts

  has_many :favorites, dependent: :destroy
  has_many :posts, through: :favorites

  has_many :votes, dependent: :destroy
  has_many :posts, through: :votes
end
