Rails.application.routes.draw do
  devise_for :users

  mount TranslationCenter::Engine => '/translation_center'
end
