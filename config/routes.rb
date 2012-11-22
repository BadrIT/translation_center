TranslationCenter::Engine.routes.draw do
  resources :translations
  resources :translation_keys
  resources :categories
  root to: 'categories#index'
end
