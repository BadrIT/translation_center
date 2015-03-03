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
  s.license = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["spec/**/*"]

  # Development dependencies
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency "activerecord"

  # s.add_development_dependency 'debugger', '~> 1.6.5'
  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'generator_spec'
  s.add_development_dependency 'actionpack'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'pry'

  # Dependencies

  s.add_dependency "rails"#, ">= 3.1.0", "<= 3.2.12"
  s.add_dependency 'acts_as_votable'

  s.add_dependency 'ya2yaml'

  s.add_dependency 'devise'

  s.add_dependency 'audited-activerecord'

  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'font-awesome-rails'

  s.add_dependency 'haml'
  s.add_dependency 'haml-rails'
end
