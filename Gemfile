source 'http://ruby.taobao.org/'
#source 'http://rubygems.org/'


if RUBY_PLATFORM !~ /mingw/i and ENV['SINAREY_ENV'] == 'heroku'
  puts 'set ruby version at 2.0.0'
  ruby '2.0.0'
end

gem 'thin'

gem 'sinarey', '1.0.4'
gem 'sinatra-contrib'

gem 'settingslogic'
gem 'oj'
gem 'will_paginate', '~> 3.0'

if RUBY_PLATFORM =~ /mingw/i
	gem "sanitize", '~> 2.1'
else
	gem "sanitize"
end

gem 'timerizer'

#my gem
gem 'sinarey_support'

gem 'erb_safe_ext', '2.0.0'

gem 'rest-client'
gem 'ruby-hmac'

gem 'sequel'
gem 'mysql2'

#rake tasks
gem 'rake'
gem 'activerecord'