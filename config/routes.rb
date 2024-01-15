Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users

  resources :sales do
    collection do
      get 'upload_form', to: 'sales#upload_form'
      post 'calculate_balance', to: 'sales#calculate_balance'
      get 'show_result', to: 'sales#show_result'
      get 'list_sales', to: 'sales#list_sales'
    end
  end

  get 'up', to: 'rails/health#show', as: :rails_health_check

  root to: 'sales#upload_form'
end
