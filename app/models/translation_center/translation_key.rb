module TranslationCenter

  class TranslationKey < ActiveRecord::Base
    attr_accessible :name, :last_accessed, :category_id
    belongs_to :category
    has_many :translations, dependent: :destroy

    # validations
    validates_uniqueness_of :name
    validates_presence_of :category

    # returns the accepted translation in certain language
    def accepted_translation_in(lang)
      self.translations.accepted.in(lang).first
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
          value = translation.try(:value).blank? ? '' : translation.value
          {current_level => value}
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
