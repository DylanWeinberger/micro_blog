class RemoveDatetimeColumn < ActiveRecord::Migration
  def change
  	remove_column :users, :datetime
  end
end
