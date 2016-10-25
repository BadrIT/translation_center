module TranslationCenter

  # gets the translation of a a key in certain lang and inserts it in the db
  # returns true if the translation was found in js
  def self.js2db_key(locale, translation_key, translator, all_yamls)
    I18n.locale = locale
    translation = TranslationCenter::Translation.find_or_initialize_by(translation_key_id: translation_key.id, lang: locale.to_s, translator_id: translator.id)
    translation.translator_type = TranslationCenter::CONFIG['translator_type']

    # get the translation for this key from the yamls
    value = get_translation_from_hash(translation_key.name, all_yamls[locale])

    # if the value is not empty and is different from the existing value the update
    if value.is_a? Proc
      puts "proc removed for key #{translation_key.name}"
      translation.destroy unless translation.new_record?
    elsif !value.blank? && value != translation.value
      translation.update_attribute(:value, value)
      # accept this yaml translation
      translation.accept if TranslationCenter::CONFIG['yaml2db_translations_accepted']
      true
    end
  end

  # takes array of keys and creates/updates the keys in the db with translations in the given locales
  def self.js2db_keys(keys, translator, locales, all_yamls)
    # initialize stats variables
    new_keys = 0
    missing_keys = locales.inject({}) do |memo, lang|
      memo[lang] = 0
      memo
    end

    # for each key create it in the db if it doesn't exist, and add its translation to
    # the db in every locale
    keys.each do |key|
      translation_key = TranslationCenter::TranslationKey.find_or_initialize_by(name: key)
      if translation_key.new_record?
        translation_key.save
        new_keys += 1
      end

      # for each locale create/update its translation
      locales.each do |locale|
        missing_keys[locale] += 1 unless self.js2db_key(locale, translation_key, translator, all_yamls)
      end

    end

    puts "found new #{new_keys} key(s)"
    missing_keys.each do |locale, count|
      puts "missing #{count} translation(s) for #{locale}" if count > 0
    end
  end

  # take the js translations and update the db with them
  def self.js2db(locale=nil)
    # prepare translator by creating the translator if he doesn't exist
    translator = TranslationCenter.prepare_translator

    # if couldn't create translator then print error msg and quit
    if translator.blank?
      puts "ERROR: Unable to create default translator with #{TranslationCenter::CONFIG['identifier_type']} = #{TranslationCenter::CONFIG['yaml_translator_identifier']}"
      puts "Create this user manually and run the rake again"
      return false
    end

    # Make sure we've loaded the translations
    I18n.backend.send(:init_translations)
    puts "#{I18n.available_locales.size} #{I18n.available_locales.size == 1 ? 'locale' : 'locales'} available: #{I18n.available_locales.join(', ')}"

    # Get all keys from all locales
    #TODO
    all_jss = I18n.backend.send(:translations)
    all_keys = all_ss.collect do |check_locale, translations|
      collect_keys([], translations).sort
    end.flatten.uniq
    puts "#{all_keys.size} #{all_keys.size == 1 ? 'unique key' : 'unique keys'} found."

    locales = locale.blank? ? I18n.available_locales : [locale.to_sym]

    # create records for all keys that exist in the js
    js2db_keys(all_keys, translator, locales, all_yamls)
  end

  def self.db2js(locale=nil)
    locales = locale.blank? ? I18n.available_locales : [locale.to_sym]

    # for each locale build a hash for the translations and write to file
    locales.each do |locale|
      result = {}
      I18n.locale = locale
      puts "Started exporting translations in #{locale}"
      TranslationCenter::TranslationKey.translated(locale).each do |key|
        begin
          key.add_to_hash(result, locale)
        rescue
          puts "Error writing key: #{key.name} to yaml for #{locale}"
        end
      end
      File.open("app/assets/javascripts/webapp/locales/#{locale.to_s}.js", 'w') do |file|
        file.write({locale.to_s => result}.ya2yaml)
      end
      puts "Done exporting translations of #{locale} to #{locale.to_s}.js"
    end
  end
end
