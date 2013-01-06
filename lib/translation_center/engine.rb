require "jquery-rails"
require 'mysql2'
require 'haml'
require 'haml-rails'
require 'acts_as_votable'
require 'ya2yaml'
require 'will_paginate'
require 'devise'
require 'meta_search'
require 'js-routes'
require 'font-awesome-rails'
require 'audited-activerecord'
require 'bootstrap-datepicker-rails'
require 'meta_search'

module TranslationCenter
  class Engine < ::Rails::Engine
    isolate_namespace TranslationCenter
  end
end
