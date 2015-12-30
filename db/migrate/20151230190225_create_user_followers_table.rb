class CreateUserFollowersTable < ActiveRecord::Migration
  def change
  	create_table :user_followers do |uf|
  		uf.integer :user_id
  		uf.integer :user_follower_id
  end
end
