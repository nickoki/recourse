# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Require seed data files
require_relative './user_data.rb'
require_relative './post_data.rb'

# Truncate tables
Vote.destroy_all
Bookmark.destroy_all
Post.destroy_all
User.destroy_all

# user_data = get_user_data()
# post_data = get_post_data()
#
# user_data.each_pair do |user_name, user_info|
#   new_user = User.create! user_info
#   new_post = post_data[user_name]
#   Post.create!(new_post.merge(user: new_user))
# end

# users
nick = User.create!(email: "nick@nick.nick", password: "okioki")
barrett = User.create!(email: "bar@bar.bar", password: "barbar")
tim = User.create!(email: "tim@tim.tim", password: "timtim")

# posts
one = Post.create!(user: nick, link: "http://railscasts.com/episodes/182-cropping-images?view=asciicast", title: "Image Cropping & Hosting Guide")
two = Post.create!(user: barrett, link: "https://github.com/bcope/tutorials/blob/master/atom-snippets.md", title: "Atom Snippets Tutorial")
three = Post.create!(user: tim, link: "https://chriswrightdesign.com/experiments/flexbox-adventures/", title: "Flexbox Adventures")

# bookmarks
Bookmark.create!(user: nick, post: two)
Bookmark.create!(user: barrett, post: three)
Bookmark.create!(user: tim, post: one)

# votes
Vote.create!(user: nick, post: two, vote_type: "up")
Vote.create!(user: barrett, post: one, vote_type: "up")
Vote.create!(user: tim, post: one, vote_type: "up")
Vote.create!(user: nick, post: three, vote_type: "down")
Vote.create!(user: barrett, post: three, vote_type: "down")
Vote.create!(user: tim, post: two, vote_type: "down")
# the vote below should not be allowed to be created so including it for testing validation
# nick already up voted that post - should not be allowed to have both types of vote for a given post
# Vote.create!(user: nick, post: two, vote_type: "down")
# barrett already up voted that post - should not be allowed to vote on a post more than once
# Vote.create!(user: barrett, post: three, vote_type: "down")
# tim should not be able to vote on his own post
# Vote.create!(user: tim, post: three, vote_type: "down")
