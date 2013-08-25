require 'jquery-rails'
require 'jquery-ui-rails'
require 'haml'
require 'haml-rails'
require 'acts_as_votable'
require 'ya2yaml'
require 'font-awesome-rails'
require 'audited-activerecord'

module TranslationCenter

  class Engine < ::Rails::Engine
    isolate_namespace TranslationCenter
  end
end
