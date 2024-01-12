Rails.application.routes.draw do
  # Rotas RESTful para usuários
  resources :users

  # Rotas RESTful para sessões (login e logout)
  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # Rotas adicionais para as ações específicas relacionadas às vendas
  resources :sales do
    collection do
      get 'upload_form', to: 'sales#upload_form'
      post 'calculate_balance', to: 'sales#calculate_balance'
      get 'show_result', to: 'sales#show_result'
      get 'list_sales', to: 'sales#list_sales'
    end
  end

  # Rota de saúde do Rails
  get 'up', to: 'rails/health#show', as: :rails_health_check

  # Rota padrão para a página inicial
  root to: 'sales#upload_form'
end
