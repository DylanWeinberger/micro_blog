class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :username
  		t.string :password
  		t.datetime :birthday
  	end
  end
end
