module TranslationCenter

  class TranslationKey < ActiveRecord::Base
    attr_accessible :name, :last_accessed, :category_id
    belongs_to :category
    has_many :translations, dependent: :destroy

    # validations
    validates :name, uniqueness: true
    validates :category, presence: true

    # called after key is created
    after_create :add_category

    PER_PAGE = 7

    # add a category of this translation key
    def add_category
      category_name = self.name.to_s.split('.').first
      category = Category.find_or_initialize_by_name(category_name)
      category.save if category.new_record?
      self.update_attribute(:category, category)
      self.update_attribute(:last_accessed, Time.now)
    end

    # returns true if the key has an accepted translation in this lang
    def accepted_in?(lang)
      !self.accepted_translation_in(lang).blank?
    end
    alias_method :translated_in?, :accepted_in?

    # returns the accepted translation in certain language
    def accepted_translation_in(lang)
      self.translations.accepted.in(lang).first
    end

    # returns true if the translation key has no translations in the language
    def no_translations_in?(lang)
      self.translations.in(lang).empty?
    end
    alias_method :untranslated_in?, :no_translations_in?

    # returns true if the key has translations in the language
    def has_translations_in?(lang)
      !no_translations_in?(lang)
    end

    # returns true if the key has translations but none are accepted
    def pending_in?(lang)
      !accepted_in?(lang) && !untranslated_in?(lang)
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
          {current_level => translation.value}
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
