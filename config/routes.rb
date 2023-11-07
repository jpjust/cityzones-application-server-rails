Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'session#new'

  resources :session, :only => [:new, :create, :destroy]
  resources :users
  resources :password_recovery, :only => [:new, :create, :edit, :update]
  resources :countries, :only => [:index]
  resources :pages, :only => [:show]
  
  resources :tasks, :only => [:index, :new, :create, :destroy] do
    resources :config, :only => [:index]
    resources :results, :only => [:index] do
      resources :data, :only => [:index]
    end
  end
  
  namespace :admin do
    resources :workers
  end
  
  namespace :api do
    resources :tasks, :only => [:index, :update]
    get '/cells/:left/:top/:right/:bottom', :to => 'cells#index'
  end

end
