Rails.application.routes.draw do
  devise_for :users

  mount TranslationCenter::Engine => '/translation_center'

  root :to => 'articles#index'
end
