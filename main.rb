require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'active_support/all'

set :database, "sqlite3:micro_blog.sqlite3"

enable :sessions

get '/' do
  if current_user
    current_user 
    erb :home
  else
    erb :sign_in
  end
end

get '/sign_in' do
	erb :sign_in
end

post '/sign_in' do
  # assign the variable @user to the user that has the
  # same username given inside of the params hash use .first because .where always returns an array
  @user = User.where(username: params[:username]).first
  # check if user's password is equal to submitted password
  	if @user.password == params[:password]
      session[:user_id] = @user.id
      current_user
    #send them to the profile page, invoke current_user function to set session, all_users to get all users
    all_users
    erb :profilePage

  	else
    # otherwise, send them to the ‘login-failed' page
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
    #display error message if not all fields are filled.
    redirect "/completeProfile", :error => 'All profile fields are required!'
  end
end

get '/profilePage' do
  current_user
  all_users
  erb :profilePage
end

# a page where users can follow other users
get '/followUsers' do
  current_user
  @printAllUsers = User.all
  erb :followUsers
end

get '/sign_out' do
  current_user
  log_out
  # This route will be called when someone clicks on logout.
  erb :sign_out
end

get '/account_delete' do
# This will reroute to a new page saying their account is deleted.
  current_user
  destroy_user
  erb :account_delete
end

get "/postsindex" do
  # This will navigate to the posts folder and find the index in there. This is the posts homepage.
  current_user
  @posts = Post.order(created_at: :desc)
  @title = "Welcome."
  erb :postsindex
end

get "/create" do
  # This is the route for creating new posts.
 current_user
 @title = "Create post"
 @post = Post.new
 erb :create
end

  # This route is taking the paramaters entered in the create route and redirecting them to a new place to save them as their id.
post "/create" do
 if current_user
 @post = Post.new(title: params[:title], content: params[:content], user_id: "#{@currentUser.id}")
  if @post.content.length < 151 && @post.title != ""
    @post.save
    redirect "/#{@post.id}", :notice => 'Congrats! Love the new post.'
    # redirect "/postsindex"
  elsif @post.content.length > 150
    redirect "/create", :error => 'Your post was too long. Maximum 150 Characters'
  elsif @post.title == ""
    redirect "/create", :error => 'Your post needs a title. Try again.'
  end
  else
    redirect "/create", :error => 'You need to be logged in to make a post'
 end
end

get "/postsfeed" do
  # This will navigate to the posts folder and find the index in there. This is the posts homepage.
  current_user
  @posts = Post.order(created_at: :desc).take(10)
  @title = "Welcome."

  erb :postsfeed
end

get "/userfeed" do
  current_user
  # this route will display all the current users posts.
  # I will find the posts.where user_id == @currentUser.id
  if current_user
    @posts = Post.all.find(:user_id == @currentUser.id)
    erb :postsindex
  end
end

get "/:id" do
  current_user
  # This route will allow us to navigate through the different posts
 @post = Post.find(params[:id])
 @title = @post.title
 erb :view
end

post '/updateProfile' do
  current_user
  #Removes empty values from params hash, so profile does not get updated with blank values
  params.each do |type, value|
    if value == ""
      params.except!(type)
      puts params
    else
    #updates the profile with the new information
    @currentUser.profile.update({type => value})
    end
  end
  redirect '/profilePage', :notice => 'Profile was updated successfully.'
end

get '/followUsers' do
  current_user
  erb :followUsers
end

#this is the routing for when a user clicks the button to follow another user
post '/follow' do
  follow_user
  current_user
  #notifies the signed in user of which user they just started following
  redirect '/followUsers', :notice => "You are now following #{@nowFollowing}!"
end

post '/viewProfilePage' do
  @viewProfileInfo = User.find(params[:followID])
  @viewProfilePosts = User.find(params[:followID]).posts
  erb :viewProfilePage
end

# This function will call the current user method to make sure there is a user. Then it destroys the user currently logged in.
def destroy_user
 current_user
  if current_user
    @current_user_id = @currentUser.id
    # I needed to figure out a way to log the user out and delte at the same time. It only works when the session is destroyed first.
    session["#{@currentUser.id}"] = nil
    @currentUser.destroy
  end
end

def log_out
  if current_user 
      session[:user_id] = nil
  end
end

# current user function to use if a user is signed in. Returns nil if not signed in
def current_user
  if session[:user_id] 
      @currentUser = User.find(session[:user_id])
  end   
end

def follow_user
  #check if logged in, second part is to check if user is already followed
  if current_user && unless User.find(params[:followID]).followers.exists?(:id => @currentUser.id)
    current_user
    #Take the id from params, find that user, and add current user to their followers
    @nowFollowing = User.find(params[:followID]).username
    User.find(params[:followID]).followers.push(User.find(@currentUser.id))
  else
    redirect "/followUsers", :error => "You are already following #{params[:followID]}"
  end
end
end

def no_user_redirect
  # maybe we can use something like this. If i am not logged in.
  if !current_user
    redirect "/", :error => 'You need to be logged in to access the site.'
  end
end

#all users
def all_users
  @allUsers = User.all
end

#finds a user
def user_find(i)
  @userFind = User.find(i)
end

#returns the number of users in the DB
def user_count
  @userCount = User.count
end

#checks if a user exists
def user_exists(i)
  @userExist = User.exists?(i)
end

# TODO a function that will check if a User is CurrentUser and if not redirect to a signin page with a message that says please sign in.

#this will be a function to unfollow a user

# def unfollow_user
#   if current_user
#     User.find(params[:followID]).followers.#code to remove(User.find(@currentUser.id))
#   end
# end