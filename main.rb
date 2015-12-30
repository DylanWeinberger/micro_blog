require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:micro_blog.sqlite3"
enable :sessions


get '/' do
  if current_user
    current_user 
    erb :home
  end
    erb :sign_in
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
      session[:user_id] = @user.id
      current_user
    #send them to the profile page, invoke current_user function to set session
    erb :profilePage

  	else
    # otherwise, send them to the ‘login-failed' page
    # (assuming a view/route like this exists)
    redirect '/signup'
	end 

end	

# current user function to use if a user is signed in. Returns nil if not signed in
def current_user
  if session[:user_id] 
      @currentUser = User.find(session[:user_id])
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
  #this block grabs their newly created user ID, sets it as the session, and then reroutes them to the complete profile page
  @user = User.where(username: params[:username]).first
  session[:user_id] = @user.id
  current_user
  erb :completeProfile
end


get '/completeProfile' do
  erb :completeProfile
end

post '/completeProfile' do
  if params[:name] != "" && params[:city] != "" && params[:age] != "" && params[:lname] != ""
    current_user
    #create a new profile, and use the current session id since they are already signed in as the foriegn key with that profile.
    Profile.create(name: params[:name], city: params[:city], age: params[:age], user_id: "#{@currentUser.id}", lname: params[:lname])
  erb :profilePage
  else
    #display error message here eventually
    redirect '/completeProfile'
  end
end

get '/profilePage' do
  current_user
  erb :profilePage
end

get '/testSession' do
  current_user
  erb :testSession
end

get '/sign_out' do
  log_out
  # This route will be called when someone clicks on logout.
  erb :sign_out
end

def log_out
  if current_user 
      @currentUser = nil
  end
end




