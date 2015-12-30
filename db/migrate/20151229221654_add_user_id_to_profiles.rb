class AddUserIdToProfiles < ActiveRecord::Migration
  def change
  	add_column :profiles, :user_id, :integer
  	add_column :posts, :user_id, :integer
  end
end
