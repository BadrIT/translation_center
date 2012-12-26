module TranslationCenter

  class AddLangGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    argument :langs, type: :array

    def self.next_migration_number(path)
      @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S%6N").to_i.to_s
    end

    def add_lang
      if langs.blank?
        puts 'Please provide a language to add to the translation center'
        return
      end

      langs.each do |lang|
        @lang = lang
        # check if language already supported
        if(TranslationCenter::TranslationKey.column_names.include? "#{lang}_status")
          puts 'This language is already supported, just make sure it is listed in config/translation_center.yml'
          return
        end
        # Generate migration templates for the models needed
        migration_template 'migrations/add_lang_status_translation_keys.rb', "db/migrate/add_#{lang}_status_translation_center_translation_keys.rb"
      end
      puts "Language(s) added, don't forget to add the language(s) to config/translation_center.yml"
    end
  end
end
