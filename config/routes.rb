require "sidekiq/web"

Rails.application.routes.draw do
  # Ensure Sidekiq Web UI works with sessions in API mode
  Sidekiq::Web.use Rack::Session::Cookie, secret: Rails.application.credentials.secret_key_base
  mount Sidekiq::Web => "/sidekiq"

  get "up" => "rails/health#show", as: :rails_health_check

  # API definition
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[show create update destroy]
      resources :tokens, only: [ :create ]
      resources :products, only: %i[index show create update destroy]
      resources :orders, only: %i[index show create]
    end
  end
end
