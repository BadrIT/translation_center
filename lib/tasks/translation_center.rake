require "uri"
require "net/http"

namespace :translation_center do

  def send_exception(exception)
    puts "An error has ocurred while performing this rake, would you like to send the exception to us so we may fix this problem ? press [Y/n]"
    confirm = $stdin.gets.chomp
    
    if confirm.blank? || confirm == 'y' || confirm == 'yes'
      puts 'Sending ...'
      params = {message: "#{exception.message} #{exception.backtrace.join("\n")}"}
      Net::HTTP.post_form(URI.parse('http://translation-center.herokuapp.com/translation_center_feedbacks/create_rake'), params)
      puts 'We have received your feedback. Thanks!'
    end
  end

  desc "Insert yaml translations in db"
  task :yaml2db, [:locale ] => :environment do |t, args|
    begin
      1/0
      TranslationCenter.yaml2db(args[:locale])
    rescue Exception => e
      send_exception(e)
    end
  end

  desc "Export translations from db to yaml"
  task :db2yaml, [:locale ] => :environment do |t, args|
    begin
      TranslationCenter.db2yaml(args[:locale])
    rescue Exception => e
      send_exception(e)
    end
  end

  desc "Calls yaml2db then db2yaml"
  task :synch, [:locale ] => :environment do |t, args|
    begin
      TranslationCenter.yaml2db(args[:locale])
      TranslationCenter.db2yaml(args[:locale])
    rescue Exception => e
      send_exception(e)
    end  
  end

end