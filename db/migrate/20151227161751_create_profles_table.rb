class CreateProflesTable < ActiveRecord::Migration
  def change
  	create_table :profiles do |t|
  		t.string :name
  		t.string :city
  		t.datetime :age
  	end
  end
end
