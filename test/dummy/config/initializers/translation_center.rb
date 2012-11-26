if Rails.env.development?
  module ApplicationHelper
    def t *args
      key = scope_key_by_partial(args.first)
      # add the new key or update it
      translation_key = TranslationCenter::TranslationKey.find_or_initialize_by_name(key)
      category_name = key.split('.').first
      category = TranslationCenter::Category.find_by_name(category_name)
      translation_key.update_attribute(:category, category)
      translation_key.update_attribute(:last_accessed, Time.now)
        
      super
    end
  end
end

# only in development we will be adding new categories using the before filter
if Rails.env.development?

  class ActionController::Base
    before_filter :add_translation_center_category

    def add_translation_center_category
      TranslationCenter::Category.create(name: controller_name) unless TranslationCenter::Category.find_by_name(controller_name)
    end
  end
  
end

