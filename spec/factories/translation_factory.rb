FactoryGirl.define do
  factory :translation, :class => TranslationCenter::Translation do
    lang "en"
    status "pending"
    translation_key
    value "value"
    translator
  end
end