Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  resources :recipes do
    member do
      post :parse
    end
  end

  resources :steps
  resources :ingredients
end
