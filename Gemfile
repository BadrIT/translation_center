source "http://rubygems.org"

####################################################################
####################################################################
###########################IMPORTANT################################
####################################################################
####################################################################
# When add new gem, don't forget to add it to 
# 1- engine.rb
# 2- translation_center.gemspec
####################################################################

# Declare your gem's dependencies in translation_center.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"
gem 'mysql2'
gem 'haml'
gem 'haml-rails'
gem 'acts_as_votable'
gem 'ya2yaml'
# gem 'linecache19', :git => 'git://github.com/mark-moseley/linecache'
gem 'will_paginate'
gem 'devise'
gem 'meta_search'
gem 'js-routes'
gem 'font-awesome-rails'

group :assets do
  gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
end

group :development do
  gem 'ruby-debug-base19x', '~> 0.11.30.pre4'
  gem 'ruby-debug19'
  gem 'debugger'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
