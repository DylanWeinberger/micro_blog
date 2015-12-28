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
    redirect '/profile'
    # set their the session to the current user
    session[:user_id] = @user.id
  	else
    # otherwise, send them to the ‘login-failed' page
    # (assuming a view/route like this exists)
    redirect '/signup'
	end 
end	

get '/signup'  do
  erb :signup 
end

post '/signup' do
  #check for basic empty fields
  if params[:username] != "" && params[:password] != "" && params[:email] != "" && params[:birthday] != ""
    #create the new user and insert into database
    User.create(username: params[:username], password: params[:password], email: params[:email], birthday: params[:birthday])
  else
    #eventually display error message here if fields are blank
    redirect '/signup'
  end
  #redirect them to a temporary signup success page
  erb :signup_success
end


get '/profile' do
  session[:user_id] = @user.id
  erb :profile

end

