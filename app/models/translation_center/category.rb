module TranslationCenter
  class Category < ActiveRecord::Base
    attr_accessible :name
    has_many :translation_keys

    # validations
    validates_presence_of :name
    validates_uniqueness_of :name
  end
end
