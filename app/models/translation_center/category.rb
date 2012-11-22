module TranslationCenter
  class Category < ActiveRecord::Base
    attr_accessible :name
    has_many :translation_keys
  end
end
