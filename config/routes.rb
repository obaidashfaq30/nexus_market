Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :admin do
    resources :tenants, only: [:new, :create, :index, :show] do
      resources :products
      resources :orders, only: [:index, :show]
    end
    get "dashboard", to: "dashboard#index"
  end
  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
