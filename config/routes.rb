Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }

  resources :pets do
    collection do
      get "top"
    end

    member do
      post "photo"
    end
  end

  root "pets#index"
end
