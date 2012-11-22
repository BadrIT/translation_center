module TranslationCenter

  class TranslationKey < ActiveRecord::Base
    attr_accessible :name, :last_accessed, :category_id
    belongs_to :category
    has_many :translations, dependent: :destroy

    validates_uniqueness_of :name

    def accepted_translation_in(lang)
      self.translations.accepted.in(lang).first
    end

    def add_to_hash(all_translations, lang)
      levels = self.name.split('.')
      add_to_hash_rec(all_translations, levels, lang.to_s)
    end

    private
      def add_to_hash_rec(all_translations, levels, lang)
        current_level = levels.first
        if(levels.count == 1)
          translation = self.accepted_translation_in(lang)
          value = translation.try(:value).blank? ? '' : translation.value
          {current_level => value}
        else
          
          unless(all_translations.has_key?(current_level))
            all_translations[current_level] = {}
            all_translations.merge!({levels.shift => add_to_hash_rec(all_translations[current_level],levels, lang)})
          else
            levels.shift
            all_translations[current_level].merge!( add_to_hash_rec(all_translations[current_level],levels, lang) )
            all_translations
          end
        end
      end

  end

end
