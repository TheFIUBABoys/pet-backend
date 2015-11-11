Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }

  devise_scope :user do
    get "/users/profile" => "users/sessions#show"
  end

  devise_scope :user do
    put "/users/profile" => "users/sessions#update"
  end

  resources :pets do
    member do
      put "report"
      put "block"
      put "block_owner"
    end
    collection do
      get "top"
      get "reported"
      get "reported_users"
      post "block_owner_publications"
    end

    resources :images, only: [:show, :create, :destroy]
    resources :adoption_requests, only: [:index, :create] do
      post "accept", on: :member
    end
    resources :questions, only: [:index, :show, :create] do
      post "answer"
    end
  end

  resources :reports, only: [:index]
  root "reports#index"
end
