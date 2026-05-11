Rails.application.routes.draw do
  root "dashboard#index"

  # Admin Dashboard Route
  get "admin/dashboard", to: "admin#index", as: :admin_dashboard
  get "admin/users", to: "admin#users", as: :admin_users # Dedicated User list
  # Admin specific user management
  get "admin/users/:id/logs", to: "admin#user_logs", as: :admin_user_logs
  # Admin Stats Route
  get "admin/stats", to: "admin#stats", as: :admin_stats


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

  # THIS IS THE MISSING LINE:
  resources :heart_rate_logs, path: 'logs'

  # 3. HEALTH PROFILE (The new part we discussed)
  resource :profile, only: [:show, :edit, :update]

  # Account Settings
  resource :settings, only: [:show, :update, :destroy] do
    get 'security', on: :member # For changing password
    patch 'deactivate', on: :member # New route for deactivation
  end

  resources :users, only: [:update] # Add this for the admin toggle

end