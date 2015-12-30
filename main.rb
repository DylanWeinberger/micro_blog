require 'sinatra'
require 'sinatra/activerecord'
require './models'
# require 'sinatra-flash'
# require 'sinatra-redirect-with-flash'
# I cannot get the app to run when these two are required
# may not need to require these two files


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
  current_user
  log_out
  # This route will be called when someone clicks on logout.
  erb :sign_out
end

get '/account_delete' do
# This will reroute to a new page saying their account is deleted.
  current_user
  destroy_user
  log_out
  erb :account_delete
end

# get '/newpost' do
#   erb :newpost
# end

# get '/posts' do
#   @posts = Post.order("created_at DESC")
#   erb :posts
# end

# post '/newpost' do
#   if current_user
#     current_user
#   #check for basic empty fields
#   if params[:title] != "" && params[:content] != ""
#     #create the new user and insert into database
#     @currentpost = Post.create(title: params[:title], content: params[:content])
#     erb :posts
#   elsif params[:title] != "" && params[:content].length > 150


#   #   #eventually display error message here if fields are blank
#   #   redirect '/newpost'
#   end

#   #this block grabs their newly created user ID, sets it as the session, and then reroutes them to the complete profile page
# end
# end
# I'm starting the posting over using a template I found
get "/postsindex" do
  # This will navigate to the posts folder and find the index in there. This is the posts homepage.
  current_user
  @posts = Post.order("created_at DESC")
  @title = "Welcome."
  erb :"postsindex"
end




get "/create" do
  # This is the route for creating new posts.
 current_user
 @title = "Create post"
 @post = Post.new
 erb :"create"
end

  # This route is taking the paramaters entered in the create route and redirecting them to a new place to save them as their id.
post "/posts" do
 current_user
 @post = Post.create(title: params[:title], content: params[:content], user_id: "{@currentUser.id}")
   if @post.save
    redirect "posts/#{@post.id}"
   else
   erb :"create"
  end
end

get "/posts/:id" do
  current_user
  # This route will allow us to navigate through the different posts
 @post = Post.find(params[:id])
 @title = @post.title
 erb :"view"
end



helpers do
  # Not sure what this does but the tutorial im following suggested it
  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end
end

def destroy_user
  # This method will call the current user method to make sure there is a user. Then it destroys the user currently logged in.
  if current_user
    @currentUser.destroy
  end
end

def log_out
  if current_user 
      session[:user_id] = nil
  end
end

post '/updateProfile' do
  current_user
  if params[:name] != ""
    @currentUser.profile.save(params [:name])
  end
end




