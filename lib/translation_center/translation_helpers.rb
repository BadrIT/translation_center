module TranslationCenter

  def self.included(base)
    base.class_eval do
      alias_method_chain :translate, :adding
    end
  end

  def translate_with_adding(locale, key, options = {})
    # add the new key or update it
    translation_key = TranslationCenter::TranslationKey.find_or_initialize_by_name(key)
    translation_key.update_attribute(:last_accessed, Time.now)

    # just return the normal I18n translation
    translate_without_adding(locale, key, options)
  end

  # load tha translation config
  CONFIG = YAML.load_file("config/translation_center.yml")[Rails.env]
  I18n.available_locales = CONFIG['lang'].keys

end

I18n::Backend::Base.send :include, TranslationCenter



