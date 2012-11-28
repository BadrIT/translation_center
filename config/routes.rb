TranslationCenter::Engine.routes.draw do
  resources :translations
  resources :translation_keys
  resources :categories  do
    get :translated_keys
    get :pending_keys
    get :untranslated_keys
  end
  root to: 'categories#index'

  # set the language from and to for the user
  post "/set_language_from" => 'center#set_language_from', as: :set_lang_from
  post "/set_language_to" => 'center#set_language_to', as: :set_lang_to
end
