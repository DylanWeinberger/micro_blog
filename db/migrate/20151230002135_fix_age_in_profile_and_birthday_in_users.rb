class FixAgeInProfileAndBirthdayInUsers < ActiveRecord::Migration
  def change
  	remove_column :profiles, :age
  	add_column :profiles, :age, :integer
  	remove_column :users, :birthday
  	add_column :users, :birthday, :string
  	remove_column :posts, :birthday
  	change_table(:users) { |t| t.timestamps }
  	change_table(:posts) { |t| t.timestamps }
  	change_table(:profiles) { |t| t.timestamps }
  end
end
