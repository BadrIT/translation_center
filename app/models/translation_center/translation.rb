module TranslationCenter
  class Translation < ActiveRecord::Base

    # attr_accessible :value, :lang, :translation_key_id, :user_id, :status
    # serialize as we could store arrays
    CHANGES_PER_PAGE = 5
    NUMBER_PER_PAGE = 15

    # Statuses
    ACCEPTED = "accepted"
    PENDING = "pending"

    # Relations
    belongs_to :translation_key
    belongs_to :translator, polymorphic: true

    # Validations
    validates :translation_key_id, :lang, :status, :value, presence: true
    validate :one_translation_per_lang_per_key, on: :create

    # Scopes
    # Returns accepted transations
    scope :accepted, -> { where(status: ACCEPTED) }

    # Returns translations in a certain language
    scope :in, ->(lang) { where(lang: lang.to_s.strip) }

    # Sorts translations by number of votes
    scope :sorted_by_votes, -> do
      where('votable_type IS NULL OR votable_type = ?', 'TranslationCenter::Translation')
      .select('translation_center_translations.*, count(votes.id) as votes_count')
      .joins('LEFT OUTER JOIN votes on votes.votable_id = translation_center_translations.id')
      .group('translation_center_translations.id')
      .order('votes_count desc')
    end

    # Callbacks
    after_save :update_key_status
    after_destroy :notify_key

    alias_method :key, :translation_key
    acts_as_votable
    audited

    # Serialize as we could store arrays
    serialize :value

    # called after save to update the key status
    def update_key_status
      self.key.update_status(self.lang)
    end

    # called before destory to update the key status
    def notify_key
      self.key.update_status(self.lang)
      self.audits.destroy
    end

    # returns true if the status of the translation is accepted
    def accepted?
      self.status == ACCEPTED
    end

    # returns true if the status of the translation is pending
    def pending?
      self.status == PENDING
    end

    # Accept translation by changing its status and if there is an accepting translation
    # make it pending
    def accept
      # If translation is accepted do nothing
      unless self.accepted?
        self.translation_key.accepted_translation_in(self.lang)
          .try(:update_attribute, :status, TranslationKey::PENDING)

        # reload the translation key as it has changed
        self.translation_key.reload
        self.update_attribute(:status, ACCEPTED)
      end
    end

    # unaccept a translation
    def unaccept
      self.update_attribute(:status, PENDING)
    end

    # make sure user has one translation per key per lang
    def one_translation_per_lang_per_key
      translation_exists = Translation.exists?(
        lang: self.lang,
        translator_id: self.translator.id,
        translator_type: self.translator.class.name,
        translation_key_id: self.key.id
      )

      if translation_exists
        self.errors.add(:lang, I18n.t('translation_center.errors.one_translation_per_lang_per_key'))
      end
    end

    private

    def translation_params
      params.require(:translation).permit(:value, :lang, :translation_key_id, :user_id, :status)
    end

  end
end
