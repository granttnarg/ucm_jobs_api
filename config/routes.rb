Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  #
  namespace :api do
    namespace :v1 do
      post "signup", to: "registration#create"
      post "login", to: "authentication#create"
      post "refresh", to: "authentication#refresh"

      resources :jobs, only: [ :index, :show ] do
        resources :job_applications, only: [ :create ]
      end
      resources :languages, only: [ :index ]

      namespace :admin do
        resources :jobs, only: [ :index, :show, :create ]
      end
    end
  end
end