module TranslationCenter
  class Translation < ActiveRecord::Base

    attr_accessible :value, :lang, :translation_key_id, :user_id, :status

    belongs_to :translation_key
    belongs_to :user

    alias_method :key, :translation_key
    alias_method :voter, :user
    acts_as_votable

    # validations
    validates :translation_key_id, :lang, :status, :value, presence: true
    validate :one_translation_per_lang_per_key

    # returns accepted transations
    scope :accepted, where(status: 'accepted')

    # returns translations in a certain language
    scope :in, lambda { |lang| where(lang: lang.to_s.strip) }

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
      self.translation_key.accepted_translation_in(self.lang).try(:update_attribute, :status, 'pending')
      self.update_attribute(:status, 'accepted')
    end

    # unaccept a translation
    def unaccept
      self.update_attribute(:status, 'pending')
    end

    # make sure user has one translation per key per lang
    def one_translation_per_lang_per_key
      self_or_empty = Translation.where(lang: self.lang, user_id: self.user, translation_key_id: self.key)
      if self_or_empty.size == 0 || self_or_empty.size == 1
        true
      else
        false
        self.errors.add(:lang, I18n.t('.one_translation_per_lang_per_key'))
      end
    end

    # sort descending by number of votes
    def self.sort_by_votes(translations)
      translations.sort do |a,b|
                          if(a.votes.count > b.votes.count)
                            -1
                          elsif(b.votes.count > a.votes.count)
                            1
                          else 0
                          end
                        end
    end

  end
end
