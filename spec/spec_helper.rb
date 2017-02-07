# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'database_cleaner'
require 'simplecov'

require 'rails-controller-testing'
Rails::Controller::Testing.install

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
  ActionDispatch::Request
  require 'rspec/rails'
  require 'active_record'
  require 'action_controller/base'
  require 'factory_girl_rails'

  config.include Rails.application.routes.url_helpers
  config.include Devise::TestHelpers, type: :controller
  config.order = "random"
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:all) do
    FactoryGirl.reload
    # Rails.application.routes.draw { ':controller(/:action)' }
  end
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end

class ActionController::TestCase
  include Devise::TestHelpers
end

# ActionView::TestCase::TestController.instance_eval do
#   helper Rails.application.routes.url_helpers#, (append other helpers you need)
# end
# ActionView::TestCase::TestController.class_eval do
#   def _routes
#     Rails.application.routes
#   end
# end
