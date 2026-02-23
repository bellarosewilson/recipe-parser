Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  resources :recipes do
    member do
      post :parse
    end
    resources :comments, only: [:create], module: nil
  end

  resources :steps do
    resources :comments, only: [:create], controller: "comments"
  end

  resources :ingredients
end
