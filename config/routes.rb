Rails.application.routes.draw do
  resources :publications

  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }

  resources :pets

  root "pets#index"
end
