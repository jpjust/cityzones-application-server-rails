Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'session#index'

  # Sessão (login)
  # get   '/login',                  :to => 'sessao#autenticacao',           :as => :autenticacao
  # post  '/login',                  :to => 'sessao#login',                  :as => :login
  # get   '/logout',                 :to => 'sessao#logout',                 :as => :logout

  resources :session, :only => [:index, :create, :destroy]
  resources :users
  resources :countries, :only => [:index]
  resources :pages, :only => [:show]
  
  resources :tasks, :only => [:index, :new, :create] do
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
