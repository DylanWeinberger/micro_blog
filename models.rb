class User < ActiveRecord::Base
	has_many :posts
	has_one :profile
	has_many :followers, source: :user_follower, through: :user_followers
	has_many :user_followers
end

class UserFollower < ActiveRecord::Base
	belongs_to :user
	belongs_to :user_follower, class_name: "User"
end

class Profile < ActiveRecord::Base
	belongs_to :user
end

class Post < ActiveRecord::Base
	belongs_to :user
end