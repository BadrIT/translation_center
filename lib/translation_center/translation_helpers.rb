module TranslationCenter

  def self.included(base)
    base.class_eval do
      alias_method_chain :translate, :adding
    end
  end

  def translate_with_adding(locale, key, options = {})
    # add the new key or update it
    translation_key = TranslationCenter::TranslationKey.find_or_create_by_name(key)
    #  UNCOMMENT THIS LATER TO SET LAST ACCESSED AT
    # translation_key.update_attribute(:last_accessed, Time.now)

    # if enabled save the default value (Which is the titleized key name
    # as the translation)
    if !options[:no_default] && translation_key.translations.in(:en).empty? && TranslationCenter::CONFIG['save_default_translation']
      translation_key.create_default_translation
    end

    if options.delete(:yaml)
      # just return the normal I18n translation
      return translate_without_adding(locale, key, options)
    end

    i18n_source = TranslationCenter::CONFIG['i18n_source'] 
    if i18n_source == 'db'
      val = translation_key.accepted_translation_in(locale).try(:value) || options[:default]
      throw(:exception, I18n::MissingTranslation.new(locale, key, options)) unless val
      val
    else
      # just return the normal I18n translation
      translate_without_adding(locale, key, options)
    end
  end

  # load tha translation config
  CONFIG = YAML.load_file("config/translation_center.yml")[Rails.env]
  I18n.available_locales = TranslationCenter::CONFIG['lang'].keys

end

I18n::Backend::Base.send :include, TranslationCenter



