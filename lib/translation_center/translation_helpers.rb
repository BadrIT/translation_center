module TranslationCenter

  def self.included(base)
    base.class_eval do
      alias_method_chain :translate, :adding if(TranslationCenter::CONFIG['enabled'])
    end
  end

  # wraps a span if inspector option is set to all
  def wrap_span(translation, translation_key)
    if TranslationCenter::CONFIG['inspector'] == 'all' && translation_key.category.name != 'translation_center'
      "<span class='tc-inspector-key' data-type='#{translation_key.status(I18n.locale)}' data-id='#{translation_key.id}'> #{translation} </span>".html_safe
    else
      translation
    end
  end

  def translate_with_adding(locale, key, options = {})
    # handle calling translation with a blank key
    if key.blank?
      return translate_without_adding(locale, key, options)
    end

    # add the new key or update it
    translation_key = TranslationCenter::TranslationKey.find_or_create_by_name(key)
    #  UNCOMMENT THIS LATER TO SET LAST ACCESSED AT
    # translation_key.update_attribute(:last_accessed, Time.now)

    # save the default value (Which is the titleized key name
    # as the translation)
    if translation_key.translations.in(:en).empty? && TranslationCenter::CONFIG['save_default_translation']
      translation_key.create_default_translation
    end

    if options.delete(:yaml)
      # just return the normal I18n translation
      return wrap_span(translate_without_adding(locale, key, options), translation_key)
    end

    i18n_source = TranslationCenter::CONFIG['i18n_source'] 
    if i18n_source == 'db'
      val = translation_key.accepted_translation_in(locale).try(:value) || options[:default]
      throw(:exception, I18n::MissingTranslation.new(locale, key, options)) unless val
      wrap_span(val, translation_key)
    else
      # just return the normal I18n translation
      wrap_span(translate_without_adding(locale, key, options), translation_key)
    end
  end


  # load tha translation config
  if FileTest.exists?("config/translation_center.yml")
    TranslationCenter::CONFIG = YAML.load_file("config/translation_center.yml")[Rails.env]
  else
    puts "WARNING: translation_center will be using default options if config/translation_center.yml doesn't exists"
    TranslationCenter::CONFIG = {'enabled' => true, 'inspector' => false, 'lang' => {'en' => 'English'}, 'yaml_translator_email' => 'coder@tc.com', 'i18n_source' => 'db', 'yaml2db_translations_accepted' => true,
                                'accept_admin_translations' => true,  'save_default_translation' => true }
  end
  I18n.available_locales = TranslationCenter::CONFIG['lang'].keys

end

# override html_message to add a class to the returned span
module I18n
  class MissingTranslation
    module Base
      # added another class to be used
      def html_message
        key = keys.last.to_s.gsub('_', ' ').gsub(/\b('?[a-z])/) { $1.capitalize }
        translation_key = keys
        # remove locale
        translation_key.shift
        translation_key = TranslationCenter::TranslationKey.find_by_name(translation_key.join('.'))

        # don't change the keys that come from translation center
        if translation_key.category.name == 'translation_center' || TranslationCenter::CONFIG['inspector'] == 'off'
          %(<span class="translation_missing" title="translation missing: #{keys.join('.')}">#{key}</span>)
        else
          %(<span class="translation_missing tc-inspector-key" data-type="#{translation_key.status(I18n.locale)}" data-id="#{translation_key.id}" title="translation missing: #{keys.join('.')}">#{key}</span>)
        end
      end

    end
  end
end

I18n::Backend::Base.send :include, TranslationCenter



