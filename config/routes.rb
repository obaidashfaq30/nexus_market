Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  namespace :admin do
    resources :tenants, only: %i[new create index show] do
      resources :products
      resources :orders, only: %i[index show]
    end
    get 'dashboard', to: 'dashboard#index'
  end
  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :shops, only: %i[index show], param: :tenant_id do
    resources :orders, only: %i[new create show]
  end
end
