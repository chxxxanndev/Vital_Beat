Rails.application.routes.draw do
  root "home#index"

  # Registration
  get "signup", to: "users#new"
  post "users", to: "users#create"

  # Login
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  # Logout
  get "logout", to: "sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check
end