module TranslationCenter
  class Translation < ActiveRecord::Base

    attr_accessible :value, :lang, :translation_key_id, :user_id

    belongs_to :translation_key
    belongs_to :user

    alias_method :key, :translation_key
    alias_method :voter, :user
    acts_as_votable

    scope :accepted, where(status: 'accepted')
    scope :in, lambda { |lang| where(lang: lang.to_s) }


    def accepted?
      self.status == 'accepted'
    end

  end
end
