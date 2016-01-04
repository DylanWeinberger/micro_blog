require './main' 
web: bundle exec rackup config.ru -p $PORT
run Sinatra::Application
