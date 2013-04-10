namespace :translation_center do

  desc "Insert yaml translations in db"
  task :yaml2db, [:locale ] => :environment do |t, args|
    TranslationCenter.yaml2db(args[:locale])
  end

  desc "Export translations from db to yaml"
  task :db2yaml, [:locale ] => :environment do |t, args|
    TranslationCenter.db2yaml(args[:locale])
  end

  desc "Calls yaml2db then db2yaml"
  task :synch, [:locale ] => :environment do |t, args|
    TranslationCenter.yaml2db(args[:locale])
    TranslationCenter.db2yaml(args[:locale])
  end

end