require 'jquery-rails'
require 'jquery-ui-rails'
require 'haml'
require 'haml-rails'
require 'acts_as_votable'
require 'ya2yaml'
require 'font-awesome-rails'
require 'audited'

module TranslationCenter

  class Engine < ::Rails::Engine
    isolate_namespace TranslationCenter

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
