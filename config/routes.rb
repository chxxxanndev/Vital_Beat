Rails.application.routes.draw do
  root "home#index"

  get "signup", to: "users#new"
  post "users", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  get "logout", to: "sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check

  get "password/reset", to: "password_resets#new"
  post "password/reset", to: "password_resets#create"
  get "password/reset/edit", to: "password_resets#edit"
  patch "password/reset/edit", to: "password_resets#update"

end