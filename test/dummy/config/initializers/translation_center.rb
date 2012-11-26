module TranslationCenter

  def self.included(base)
    base.class_eval do
      alias_method_chain :translate, :adding
    end
  end

  def translate_with_adding(locale, key, options = {})
    # add the new key or update it
    translation_key = TranslationCenter::TranslationKey.find_or_initialize_by_name(key)
    category_name = key.to_s.split('.').first
    category = TranslationCenter::Category.find_or_initialize_by_name(category_name)
    category.save if category.new_record?
    translation_key.update_attribute(:category, category)
    translation_key.update_attribute(:last_accessed, Time.now)

    # just return the normal I18n translation
    translate_without_adding(locale, key, options)
  end

end

I18n::Backend::Base.send :include, TranslationCenter
