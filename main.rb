require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:micro_blog.sqlite3"
set :sessions, true


get '/' do

erb :home

end

get '/sign_in' do
	erb :sign_in
end

post '/sign_in' do
  # assign the variable @user to the user that has the
  # same username given inside of the params hash
  # use .first because .where always returns an array,
  # even if there is one result returned and we only
  # want one user
  @user = User.where(username: params[:username]).first
  # if the user found's password is equal to the submitted
  # password...
  	if @user.password == params[:password]
    #send them to the homepage
    redirect '/'
  	else
    # otherwise, send them to the ‘login-failed' page
    # (assuming a view/route like this exists)
    redirect "/signup"
	end 

end	

get '/signup'  do

erb :signup 
	
end

post '/signup' do
	
	@user = User.new(params)
	redirect '/'


end



def current_user
	 if session[:user_id]
	 @current_user = User.find(session[:user_id])
	 end
 end