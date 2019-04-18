require 'api_constraints'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  namespace :api, defaults: {format: :json} do
    resources :pages, only: [:index]
    resources :paragraphs, only: [:index]
    resources :search, only: [:index]
  end




end
