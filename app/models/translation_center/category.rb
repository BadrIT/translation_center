module TranslationCenter
  class Category < ActiveRecord::Base
    attr_accessible :name
    has_many :translation_keys, dependent: :destroy

    alias_method :keys, :translation_keys

    # validations
    validates :name, presence: true, uniqueness: true
  end
end
