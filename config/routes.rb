Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  require "sidekiq/web"

  mount Sidekiq::Web => "/sidekiq"

  ##### Webhooks Endpoints #####
  post "/webhooks/tito/sync_tickets", to: "webhooks/tito#sync_tickets"

  namespace :api do
    namespace :v1 do
      namespace :auth do
        devise_for :users,
          path: "",
          path_names: {
            sign_in: "login",
            sign_out: "logout",
            registration: "register"
          },
          controllers: {
            sessions: "api/v1/auth/sessions",
            registrations: "api/v1/auth/registrations"
          }
      end

      resource :profile, only: [ :show ], controller: "profile"
      resources :tickets, only: [ :show ]
    end
  end
end
