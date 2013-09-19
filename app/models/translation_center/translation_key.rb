module TranslationCenter

  class TranslationKey < ActiveRecord::Base
    attr_accessible :name, :last_accessed, :category_id
    belongs_to :category
    has_many :translations, dependent: :destroy

    belongs_to :parent, class_name: "TranslationKey"
    has_many :children, foreign_key: "parent_id", dependent: :destroy, class_name: "TranslationKey"

    # validations
    validates :name, uniqueness: true
    validates :name, presence: true

    # called after key is created or updated
    # before_save :add_category

    after_save :build_hierarchy
    after_destroy :notify_parent

    PER_PAGE = 7

    scope :translated, lambda { |lang| where("#{lang.to_s}_status" => 'translated') }
    scope :pending, lambda { |lang| where("#{lang.to_s}_status" => 'pending') }
    scope :untranslated, lambda { |lang| where("#{lang.to_s}_status" => 'untranslated') }
    scope :leaf, ->{
      parents_ids = TranslationKey.where('parent_id is NOT NULL').group(:parent_id).pluck(:parent_id)
      where 'id not in(?)', parents_ids
    }

    def build_hierarchy
      self.update_column(:parent_id, TranslationKey.find_or_create_by_name(self.parent_path).id) unless self.parent_path.empty?
    end

    def self.root
      TranslationKey.find_or_create_by_name "*"
    end

    def leaf?
      self.children.empty?
    end

    def path_to_root
      path = []
      node = self

      while node do
        path << node
        node = node.parent
      end

      path.reverse
    end

    def parent_path
      self.parent.present? ? self.parent.name : self.name.split('.')[0...-1].join('.')
    end

    def display_name
      self.name.split('.').last
    end

    def filtered_children(status, lang)
      return self.children unless status
      self.children.send(status, lang)
    end

    # add a category of this translation key
    def add_category
      category_name = self.name.to_s.split('.').first
      # if one word then add to general category
      category_name = self.name.to_s.split('.').size == 1 ? 'general' : self.name.to_s.split('.').first
      self.category = TranslationCenter::Category.find_or_create_by_name(category_name)
      self.last_accessed = Time.now
    end

    # this function recalculates the status of the key from its translations or from the status of the children
    # then it calls the same function on the parent to maintain the status of the whole path
    def update_status(lang)
      self.update_attribute "#{lang}_status", translations_status(lang)
      self.parent.update_status(lang) if self.parent
    end

    # returns the status of the key according to its translations or the staus of its children
    def translations_status(lang)
      if self.children.empty?
        # it's a leaf node
        translation_status_for_leaf(lang)
      else
        # intermediage or leaf node
        translation_status_for_intermediate(lang)
      end
    end

    # leaf nodes have three cases:
    # the status will be 'translated' when translations are accepted,
    # or 'untranslated' when there are no translations exist,
    # or 'pending' whern there are some translations exists but not accepted by the admin.
    def translation_status_for_leaf(lang)
      if self.translations.in(lang).blank?
        'untranslated'
      elsif !self.translations.in(lang).accepted.blank?
        'translated'
      else
        'pending'
      end
    end

    # Intermediate nodes have three cases:
    # the status will be 'translated' when all children are transalted,
    # or 'untranslated' when at least one key is untranslated,
    # or 'pending' when children statuses are translated and pending but not untranslated.
    def translation_status_for_intermediate(lang)
      if self.children.exists?("#{lang}_status" => 'untranslated')
        'untranslated'
      elsif self.children.exists?("#{lang}_status" => 'pending')
        'pending'
      else
        'translated'
      end
    end

    def notify_parent
      if self.parent
        TranslationCenter::CONFIG['lang'].keys.map { |lang| update_status(lang) }
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
      self.send("#{lang}_status")
      # if accepted_in?(lang)
        # 'translated'
      # elsif pending_in?(lang)
        # 'pending'
      # else
        # 'untranslated'
      # end
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

    def children_translations(locale)
      TranslationKey.where('name LIKE ?', "#{self.name}.%").inject({}) do |translations, child|
        translations[child.name.split('.').last.to_sym] = child.accepted_translation_in(locale).try(:value)
        translations
      end
    end

    def has_children?
      TranslationKey.where('name LIKE ?', "#{self.name}.%").count >= 1
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
