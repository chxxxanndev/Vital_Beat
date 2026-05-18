Rails.application.routes.draw do
  root "dashboard#index"

  # Admin Routes
  get "admin/dashboard",      to: "admin#index",      as: :admin_dashboard
  get "admin/users",          to: "admin#users",      as: :admin_users 
  get "admin/users/:id/logs", to: "admin#user_logs",  as: :admin_user_logs
  get "admin/stats",          to: "admin#stats",      as: :admin_stats

  # Authentication
  get "signup",   to: "users#new"
  post "users",   to: "users#create"
  get "login",    to: "sessions#new"
  post "login",   to: "sessions#create"
  get "logout",   to: "sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check

  get "password/reset", to: "password_resets#new"
  post "password/reset", to: "password_resets#create"
  get "password/reset/edit", to: "password_resets#edit"
  patch "password/reset/edit", to: "password_resets#update"

  patch 'profile/avatar', to: 'profiles#update_avatar', as: 'update_profile_avatar'

  resources :heart_rate_logs, path: 'logs'
  resource :profile, only: [:show, :edit, :update]

  resource :settings, only: [:show, :update] do
    get 'security', on: :member 
    patch 'deactivate', on: :member 
  end

  resources :users, only: [:update] 

  resources :heart_rate_logs, path: 'logs' do
    patch :restore, on: :member # Add this line
  end

end