$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "translation_center/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "translation_center"
  s.version     = TranslationCenter::VERSION
  s.authors     = ["Mahmoud Khaled"]
  s.email       = ["mahmoud.khaled@badrit.com"]
  s.homepage    = "http://www.badrit.com"
  s.summary     = "Flexible I18n translation center for Rails with web interface"
  s.description = "TranslationCenter is a web Rails interface for inserting and editing translations. Users can also suggest or vote translations for different languages and admin can accept translation."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 3.2.0"
  s.add_dependency "jquery-rails"
  s.add_dependency 'mysql2'
  s.add_dependency 'haml'
  s.add_dependency 'haml-rails'
  s.add_dependency 'acts_as_votable'
  s.add_dependency 'ya2yaml'
  s.add_dependency 'devise'
  s.add_dependency 'meta_search'
  s.add_dependency 'js-routes'
  s.add_dependency 'will_paginate'

  s.add_development_dependency "sqlite3"
end
