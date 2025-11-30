Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Root route
  root "home#index"

  # Pages routes
  get "about", to: "pages#about"
  get "projects", to: "pages#projects"
  get "contact", to: "pages#contact"
  get "cv", to: "pages#cv"

  # Blog routes
  get "/blog", to: "blog#index", as: :blog
  get "/blog/:id", to: "blog#show", as: :blog_post

  # DragonRuby routes
  get "/dragonruby", to: "dragonruby#index", as: :dragonruby
  get "/dragonruby/:slug", to: "dragonruby#show", as: :dragonruby_tutorial

  # Terminal test route
  get "/terminal-test", to: "pages#terminal_test"

  # Documentation Wiki (development only)
  if Rails.env.development?
    get "/docs", to: "docs#index", as: :docs
    get "/docs/*path", to: "docs#show", as: :doc_page

    # Mission Control - Jobs UI
    # Temporarily disabled due to queue setup issues
    # require "mission_control/jobs"
    # mount MissionControl::Jobs::Engine, at: "/jobs"
  end

  # Scribe habit tracking (development only)
  if Rails.env.development?
    namespace :scribe do
      get "/", to: "dashboard#show", as: :dashboard

      resources :workouts do
        member do
          patch :mark_reviewed
        end
      end

      resources :ingestion_events
      resources :sleep_events
      resources :journal_entries

      resources :ingestions, only: [ :index, :show, :edit, :update, :destroy ] do
        member do
          post :retry
        end
      end

      resources :utterances, only: [ :create ]
    end
  end

  # Error routes
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/422", to: "errors#unprocessable_entity", via: :all
end
