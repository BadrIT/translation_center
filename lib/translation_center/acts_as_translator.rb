module ActsAsTranslator
  def acts_as_translator
    has_many :translations, class_name: 'TranslationCenter::Translation'
    acts_as_voter

    include InstanceMethods
  end

  module InstanceMethods
    # returns the translation a user has made for a certain key in a certain language
    def translation_for(key, lang)
      self.translations.find_or_initialize_by_translation_key_id_and_lang(key.id, lang.to_s)
    end

    # returns true if the user can admin translations
    def can_admin_translations?
      true
    end
  end
end

ActiveRecord::Base.extend ActsAsTranslator