# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'database_cleaner'
require 'simplecov'

SimpleCov.start do
  add_filter '/config/'
  add_filter '/spec/'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'lib'
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

RSpec.configure do |config|
  ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
  load 'schema.rb'
  require 'rspec/rails'
  require 'active_record'
  require 'action_controller/base'
  require 'factory_girl_rails'
  
  config.include Devise::TestHelpers, type: :controller
  config.order = "random"
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:all) do
    FactoryGirl.reload
    Rails.application.routes.draw { match ':controller(/:action)' }
  end
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end

class ActionController::TestCase
  include Devise::TestHelpers
end
