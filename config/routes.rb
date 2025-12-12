Rails.application.routes.draw do
  resources :groups, only: [ :new, :create, :show ] do
    member do
      get :login
      post :authenticate
      post :generate_draw
      get :participant
      post :select_participant
      get :participant_auth
      post :authenticate_participant
      get :reveal
      post "reset_person_password/:person_id", to: "groups#reset_person_password", as: :reset_person_password
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
