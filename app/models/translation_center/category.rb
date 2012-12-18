module TranslationCenter
  class Category < ActiveRecord::Base
    attr_accessible :name
    has_many :translation_keys, dependent: :destroy

    alias_method :keys, :translation_keys

    # validations
    validates :name, presence: true, uniqueness: true

    # gets how much complete translation of category is in a certain language
    def complete_percentage_in(lang)
      if self.keys.empty?
        100
      else
        accepted_keys = accepted_keys(lang)
        100 * accepted_keys.count / self.keys.count
      end
    end

    # gets the keys accepted in a certain language that belong to a category
    def accepted_keys(lang)
      self.keys.translated(lang)
    end
    alias_method :translated_keys, :accepted_keys

    # gets the keys that have no translations in the language
    def untranslated_keys(lang)
      self.keys.reject{ |key| !key.untranslated_in?(lang) }
    end

    # gets the keys that have no translations in the language
    def pending_keys(lang)
      self.keys.pending(lang)
    end

    def all_keys(lang)
      self.keys
    end

    # returns a name that is better for presentation
    def view_name
      self.name.titleize
    end

  end
end
