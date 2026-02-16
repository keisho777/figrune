Rails.application.routes.draw do
  root "static_pages#top"
  get "/home", to: "home#index"
  get "/privacy_policy", to: "static_pages#privacy_policy"
  get "/terms_of_service", to: "static_pages#terms_of_service"
  resources :figures, only: [ :index, :new, :create, :show, :edit, :update, :destroy ] do
    get :autocomplete, on: :collection
    get :autocomplete_work, on: :collection
    get :autocomplete_shop, on: :collection
    get :autocomplete_manufacturer, on: :collection
  end
  resource :account_setting, only: [ :show ] do
    get   :edit_email
    patch :update_email
    get   :edit_password
    patch :update_password
    patch :update_email_notification_timing
    patch :update_line_notification_timing
  end
  devise_for :users, controllers: {
    registrations: "users/registrations",
    confirmations: "users/confirmations",
    omniauth_callbacks: "omniauth_callbacks"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
