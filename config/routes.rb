TranslationCenter::Engine.routes.draw do
  
  resources :translations do
    post :vote
    post :unvote
    post :accept
    post :unaccept
  end

  resources :translation_keys, except: :create do
    post :update_translation
    get :translations
    collection do 
      get :search
    end
  end

  resources :categories  do
    get :more_keys
  end

  get '/dashboard' => 'center#dashboard', as: :dashboard
  get '/search_activity' => 'center#search_activity', as: :search_activity
  post '/manage_translations' => 'center#manage', as: :manage_translations

  root to: 'categories#index'

  # set the language from and to for the user
  match "/set_language_from" => 'center#set_language_from', as: :set_lang_from
  match "/set_language_to" => 'center#set_language_to', as: :set_lang_to
end
