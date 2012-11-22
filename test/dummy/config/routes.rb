Rails.application.routes.draw do

  resources :posts


  mount TranslationCenter::Engine => "/translation_center"
  root to: 'posts#index'
end
