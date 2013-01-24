$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "translation_center/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "translation_center"
  s.version     = TranslationCenter::VERSION
  s.authors     = ["BadrIT", "Mahmoud Khaled", "Khaled Abdelhady"]
  s.email       = ["mahmoud.khaled@badrit.com"]
  s.homepage    = "http://github.com/BadrIT/translation_center"
  s.summary     = "Multi lingual web Translation Center community for Rails 3 apps"
  s.description = "Translation Center is a multi lingual web engine for Rails 3 apps. It builds a translation center community with translators and admins from your system users."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"
  s.add_dependency "jquery-rails"
  s.add_dependency 'haml'
  s.add_dependency 'haml-rails'
  s.add_dependency 'acts_as_votable'
  s.add_dependency 'ya2yaml'
  s.add_dependency 'meta_search'
  s.add_dependency 'js-routes'
  s.add_dependency 'will_paginate'
  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'audited-activerecord'
  s.add_dependency 'bootstrap-datepicker-rails'

end
