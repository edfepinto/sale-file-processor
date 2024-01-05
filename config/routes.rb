Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :sales do
    collection do
      get "upload_form", to: "sales#upload_form"
      post "calculate_balance", to: "sales#calculate_balance"
      get "show_result", to: "sales#show_result"
    end
  end

  root to: "sales#upload_form"
end
