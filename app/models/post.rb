class Post < ApplicationRecord
  belongs_to :user
  
  has_many :favorites
  has_many :users, through: :favorites

  has_many :votes
  has_many :users, through: :votes
end
