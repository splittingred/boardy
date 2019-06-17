# frozen_string_literal: true

Rails.application.routes.draw do
  resources :games, only: [:index, :show]
  resources :users, only: [:show, :collection] do
    get :collection
  end

  root 'games#index'
end
