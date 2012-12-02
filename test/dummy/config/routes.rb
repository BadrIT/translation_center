Rails.application.routes.draw do

  devise_for :users

  resources :posts


  mount TranslationCenter::Engine => "/translation_center"
  root to: 'posts#index'
end
