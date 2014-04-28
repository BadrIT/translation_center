#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

desc 'Generating documentation'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'TranslationCenter'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks
Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }

desc 'RSpec tests'
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')
task :default => :spec