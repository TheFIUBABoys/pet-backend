Rails.application.routes.draw do
  resources :publications

  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :pets

  root "pets#index"
end
