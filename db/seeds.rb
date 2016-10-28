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

# Drop tables
User.destroy_all
Post.destroy_all

user_data = get_user_data()
post_data = get_post_data()

user_data.each_pair do |user_name, user_info|
  new_user = User.create! user_info
  new_post = post_data[user_name]
  Post.create!(new_post.merge(user: new_user))
end
