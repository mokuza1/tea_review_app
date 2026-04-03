Rails.application.routes.draw do
  devise_for :users, controllers: {
    passwords: "users/passwords"
  }

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

    get "privacy", to: "static_pages#privacy"
    get "terms",   to: "static_pages#terms"

  resource :mypage, only: %i[show] do
    get :my_tea_products
    get :favorites
  end

  resources :tea_products, only: %i[index show] do
    resources :reviews, only: %i[index new create edit update destroy]
    resource :favorite, only: %i[create destroy]
  end

  resources :tea_product_submissions, except: %i[index show destroy] do
    member do
      patch :submit
    end
  end

  resources :brands, only: %i[update] do
    member do
      patch :submit
    end

    collection do
      get :search
    end
  end

  resources :flavor_categories, only: [] do
    resources :flavors, only: :index
  end

  resource :diagnostic, only: [] do
    collection do
      get  :start
      post :initialize_session
      get  "question/:step", action: :question, as: :question
      post :answer
      get  :result
    end
  end

  namespace :admin do
    root "dashboard#index"

    resources :tea_products, only: %i[index show]

    resources :tea_product_submissions, only: %i[index show] do
      member do
        patch :approve
        patch :reject
      end
    end

    resources :brands, only: %i[index show update] do
      member do
        patch :approve
        patch :reject
      end
    end

    resources :flavor_categories do
      resources :flavors, shallow: true, only: %i[index new create edit update destroy]
    end
  end
end
