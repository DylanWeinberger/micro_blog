 class User < ActiveRecord::Base
 	has_many :posts
 	has_one :profile
  end

 class Profile < ActiveRecord::Base
 	belongs_to :user
  end

 class Post < ActiveRecord::Base
 	belongs_to :user
 	validates :title, presence: true, length: { minimum: 5 }
 	validates :body, presence: true
  end