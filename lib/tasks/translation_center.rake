namespace :translation_center do

  desc "Insert yaml translations in db"
  task :yaml2db => :environment do

    def collect_keys(scope, translations)
      full_keys = []
      translations.to_a.each do |key, translations|
        new_scope = scope.dup << key
        if translations.is_a?(Hash)
          full_keys += collect_keys(new_scope, translations)
        else
          full_keys << new_scope.join('.')
        end
      end
      return full_keys
    end

    # Make sure we've loaded the translations
    I18n.backend.send(:init_translations)
    puts "#{I18n.available_locales.size} #{I18n.available_locales.size == 1 ? 'locale' : 'locales'} available: #{I18n.available_locales.to_sentence}"

    # Get all keys from all locales
    all_keys = I18n.backend.send(:translations).collect do |check_locale, translations|
      collect_keys([], translations).sort
    end.flatten.uniq
    puts "#{all_keys.size} #{all_keys.size == 1 ? 'unique key' : 'unique keys'} found."

    all_keys.each do |key|
      translation_key = TranslationCenter::TranslationKey.find_or_initialize_by_name(key)
      if translation_key.new_record?
        translation_key.update_attributes(name: key)
        new_keys += 1
      end

      I18n.available_locales.each do |locale|
        missing_count = 0
        new_keys = 0
        puts "Translating keys to #{locale.to_s}"
        I18n.locale = locale
        begin
          translation = TranslationCenter::Translation.find_or_initialize_by_translation_key_id_and_lang(translation_key.id, locale.to_s)
          value = I18n.translate(key, :raise => true)
          translation.update_attribute(:value, value)
        rescue I18n::MissingInterpolationArgument
          # noop
        rescue I18n::MissingTranslationData
          missing_count += 1
        end

        puts "found new #{new_keys} key(s)"
        puts "missing #{missing_count} translation(s)"
      end
      
    end
  end

  desc "Export translations from db to yaml"
  task :db2yaml => :environment do
    # for each locale build a hash for the translations and write to file
    I18n.available_locales.each do |locale|
      result = {}
      I18n.locale = locale
      puts "Started exporting translations in #{locale}"
      TranslationCenter::TranslationKey.all.each do |key|
        key.add_to_hash(result, locale) 
      end
      File.open("config/locales/#{locale.to_s}.yml", 'w') do |file|
        file.write({locale.to_s => result}.ya2yaml)
      end
      puts "Done exporting translations of #{locale} to #{locale.to_s}.yml"
    end 
    
  end

  
end