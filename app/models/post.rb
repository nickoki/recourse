class Post < ApplicationRecord
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites

  has_many :votes, dependent: :destroy
  has_many :users, through: :votes
end
