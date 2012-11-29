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

  end
end
