module TranslationCenter

  class TranslationKey < ActiveRecord::Base
    attr_accessible :name, :last_accessed, :category_id
    belongs_to :category
    has_many :translations, dependent: :destroy

    # validations
    validates :name, uniqueness: true
    validates :name, presence: true

    # called after key is created or updated
    before_save :add_category

    PER_PAGE = 7

    scope :translated, lambda { |lang| where("#{lang.to_s}_status" => 'translated') }
    scope :pending, lambda { |lang| where("#{lang.to_s}_status" => 'pending') }
    scope :untranslated, lambda { |lang| where("#{lang.to_s}_status" => 'untranslated') }


    # add a category of this translation key
    def add_category
      category_name = self.name.to_s.split('.').first
      # if one word then add to general category
      category_name = self.name.to_s.split('.').size == 1 ? 'general' : self.name.to_s.split('.').first
      self.category = TranslationCenter::Category.find_or_create_by_name(category_name)
      self.last_accessed = Time.now
    end

    # updates the status of the translation key depending on the translations
    def update_status(lang)
      if self.translations.in(lang).blank?
        self.update_attribute("#{lang}_status", 'untranslated')
      elsif !self.translations.in(lang).accepted.blank?
        self.update_attribute("#{lang}_status", 'translated')
      else
        self.update_attribute("#{lang}_status", 'pending')
      end
    end

    # returns true if the key is translated (has accepted translation) in this lang
    def accepted_in?(lang)
      self.send("#{lang}_status") == 'translated'
    end
    alias_method :translated_in?, :accepted_in?

    # returns the accepted translation in certain language
    def accepted_translation_in(lang)
      self.translations.accepted.in(lang).first
    end

    # returns true if the translation key is untranslated (has no translations) in the language
    def no_translations_in?(lang)
      self.send("#{lang}_status") == 'untranslated'
    end
    alias_method :untranslated_in?, :no_translations_in?

    # returns true if the key has translations in the language
    def has_translations_in?(lang)
      !no_translations_in?(lang)
    end

    # returns true if the key is pending (has translations but none is accepted)
    def pending_in?(lang)
      self.send("#{lang}_status") == 'pending'
    end

    # returns the status of the key in a language
    def status(lang)
      if accepted_in?(lang)
        'translated'
      elsif pending_in?(lang)
        'pending'
      else
        'untranslated'
      end
    end

    # create default translation
    def create_default_translation
      translation = self.translations.build(value: self.name.to_s.split('.').last.titleize,
                                            lang: :en, status: 'accepted')
      translation.translator = TranslationCenter.prepare_translator

      translation.save
    end

    def self.keys_count
      TranslationKey.all.count
    end

    # returns the count of translated keys in lang
    def self.translated_count(lang)
      TranslationKey.translated(lang).count
    end

    # returns the count of pending keys in lang
    def self.pending_count(lang)
      TranslationKey.pending(lang).count
    end

    # returns the count of untranslated keys in lang
    def self.untranslated_count(lang)
      TranslationKey.untranslated(lang).count
    end

    # returns the percentage of translated keys in lang
    def self.translated_percentage(lang)
      (100.0 * TranslationKey.translated(lang).count / keys_count).round(2)
    end

    # returns the percentage of pending keys in lang
    def self.pending_percentage(lang)
      (100.0 * TranslationKey.pending(lang).count / keys_count).round(2)
    end

    # returns the percentage of untranslated keys in lang
    def self.untranslated_percentage(lang)
      (100.0 * TranslationKey.untranslated(lang).count / keys_count).round(2)
    end

    # builds hash of stats about the langs supported by translation center
    def self.langs_stats
      stats = {}
      all_count = keys_count
      I18n.available_locales.each do |locale|
        stats[locale] = {}
        stats[locale]['name'] = TranslationCenter::CONFIG['lang'][locale.to_s]['name']

        translated = translated_count(locale)
        pending = pending_count(locale)
        untranslated = untranslated_count(locale)

        stats[locale]['translated_percentage'] = (100.0 * translated / all_count).round(2)
        stats[locale]['pending_percentage'] = (100.0 * pending / all_count).round(2)
        stats[locale]['untranslated_percentage'] = (100.0 * untranslated / all_count).round(2)

        stats[locale]['translated_count'] = translated
        stats[locale]['pending_count'] = pending
        stats[locale]['untranslated_count'] = untranslated
      end
      stats
    end

    # adds a translation key with its translation to a translation yaml hash
    # send the hash and the language as parameters
    def add_to_hash(all_translations, lang)
      levels = self.name.split('.')
      add_to_hash_rec(all_translations, levels, lang.to_s)
    end

    private
      def add_to_hash_rec(all_translations, levels, lang)
        current_level = levels.first
        # if we are at the bottom level just return the translation
        if(levels.count == 1)
          translation = self.accepted_translation_in(lang)
          formatted = translation.value
          # in case of arrays remove the unneeded header
          formatted.to_yaml.gsub!("---\n" , '') if formatted.is_a?(Array)
          {current_level => formatted}
        else
          levels.shift
          # if the translation key doesn't exist at current level then create it
          unless(all_translations.has_key?(current_level))
            all_translations[current_level] = {}
          end
          # merge the current level with the rest of the translation key
          all_translations[current_level].merge!( add_to_hash_rec(all_translations[current_level],levels, lang) )
          all_translations
        end
      end

  end

end
