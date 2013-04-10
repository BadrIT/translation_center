require "translation_center/engine"
require "translation_center/acts_as_translator"
require "translation_center/translation_helpers"
require "translation_center/translations_transfer"

module TranslationCenter

  # add translations for translations center
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'translation_center', 'locale', '*.yml')]
end


