source 'https://rubygems.org'
# in your Gemfile
gem 'activerecord'
# the actual ActiveRecord library
gem 'sinatra-activerecord'
# the adapter between Sinatra and
# the ActiveRecord library

group :development, :test do
  gem 'sqlite3'
end

group :production do
	gem 'pg', '~> 0.18.4'
end

# the database adapter to use the
# sqlite3 db system with ActiveRecord
gem 'rake'
# a command line task runner (more on this
# later)
gem 'sinatra-flash'
gem 'sinatra-redirect-with-flash'

gem 'activesupport', '~> 4.2', '>= 4.2.5'
