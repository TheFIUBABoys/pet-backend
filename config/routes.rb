Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }

  resources :pets do
    collection do
      get "top"
    end

    resources :images, only: [:show, :create, :destroy]
    resources :adoption_requests, only: [:index, :create]
    resources :questions, only: [:show, :create] do
      post "answer"
    end
  end

  root "pets#index"
end
