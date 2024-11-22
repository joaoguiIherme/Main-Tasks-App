Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/register", to: "users#new"

  post '/notifications/update_task_status', to: 'notifications#update_task_status'
  get "/notifications", to: "notifications#index"

  resources :tasks
  resources :users, only: [:create]

  root to: "tasks#index"
end
