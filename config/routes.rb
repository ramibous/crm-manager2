Rails.application.routes.draw do
  devise_for :managers
  devise_for :staffs

  get 'dashboard', to: 'dashboard#index'
  get 'clients/search', to: 'clients#search', as: 'search_clients'

  resources :campaigns do
    collection do
      get 'load_clients'
    end

    resources :messages, only: [:index, :new, :create]
  end

  resources :staffs do
    member do
      get :clients
    end
  end

  resources :purchases
  resources :clients do
    resources :interactions, only: [:new, :create]
    resources :appointments, only: [:new, :create]
    resources :notes, only: [:new, :create]
    resources :wishlist_items, only: [:new, :create, :destroy, :edit, :update]

    member do
      get 'details', to: 'clients#details'
    end

    collection do
      get :export, to: 'clients#export'
      get :wishlist, to: 'clients#wishlist'
    end
  end

  resources :appointments, only: [:index]

  root 'dashboard#index'
end
