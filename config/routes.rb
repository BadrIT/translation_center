TranslationCenter::Engine.routes.draw do
  resources :translations
  resources :translation_keys
  resources :categories
  root to: 'categories#index'

  # set the language from and to for the user
  post "/set_language_from" => 'center#set_language_from', as: :set_lang_from
  post "/set_language_to" => 'center#set_language_to', as: :set_lang_to
end
