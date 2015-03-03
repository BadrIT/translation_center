FactoryGirl.define do
  factory :translation, :class => TranslationCenter::Translation do
    lang "en"
    translation_key
    value "value"
    association :translator, factory: :user
  end
end