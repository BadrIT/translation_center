module TranslationCenter
  class Translation < ActiveRecord::Base

    attr_accessible :value, :lang, :translation_key_id, :user_id, :status
    cattr_accessor :translator
    # serialize as we could store arrays
    serialize :value

    belongs_to :translation_key
    belongs_to :user

    alias_method :key, :translation_key
    alias_method :voter, :user
    acts_as_votable
    audited

    # validations
    validates :translation_key_id, :lang, :status, :value, presence: true
    validate :one_translation_per_lang_per_key, on: :create

    # returns accepted transations
    scope :accepted, where(status: 'accepted')

    # returns translations in a certain language
    scope :in, lambda { |lang| where(lang: lang.to_s.strip) }

    # sorts translations by number of votes
    scope :sorted_by_votes, where('votable_type IS NULL OR votable_type = ?', 'TranslationCenter::Translation').select('translation_center_translations.*, count(votes.id) as votes_count').joins('LEFT OUTER JOIN votes on votes.votable_id = translation_center_translations.id').group('translation_center_translations.id').order('votes_count desc')

    after_save :update_key_status
    after_destroy :notify_key

    # called after save to update the key status
    def update_key_status
      if status_changed?
        self.key.update_status self.lang
      end
    end

    # called before destory to update the key status
    def notify_key
      self.key.update_status self.lang
    end

    # returns true if the status of the translation is accepted
    def accepted?
      self.status == 'accepted'
    end

    # returns true if the status of the translation is pending
    def pending?
      self.status == 'pending'
    end

    # accept translation by changing its status and if there is an accepting translation
    # make it pending
    def accept
      # if translation is accepted do nothing
      unless self.accepted?
        self.translation_key.accepted_translation_in(self.lang).try(:update_attribute, :status, 'pending')
        # reload the translation key as it has changed
        self.translation_key.reload
        self.update_attribute(:status, 'accepted')
      end
      
    end

    # unaccept a translation
    def unaccept
      self.update_attribute(:status, 'pending')
    end

    # make sure user has one translation per key per lang
    def one_translation_per_lang_per_key
      if Translation.where(lang: self.lang, user_id: self.user, translation_key_id: self.key.id).empty?
        true
      else
        false
        self.errors.add(:lang, I18n.t('.one_translation_per_lang_per_key'))
      end
    end

  end
end
