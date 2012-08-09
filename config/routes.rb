PoseidonV3::Application.routes.draw do

  # Login/logout
  # Uncomment these if you are using password authentication
  #match 'login'  => 'sessions#new', :via => :get
  #match 'login'  => 'sessions#create', :via => :post
  #match 'logout' => 'sessions#destroy', :via => :delete


  # Uncomment these for UNTD SSO authentication
  match 'login'  => 'untd_sessions#new', :via => :get
  match 'logout' => 'untd_sessions#destroy', :via => :delete


  # Resourceful routing
  resources :servers
  resources :users
  resources :target_types
  resources :script_categories
  resources :notify_groups do
    resources :notify_group_emails, :as => "emails",:only => [:index, :new, :create, :destroy]
  end
  resources :target_groups
  resources :targets do
    # Additional actions
    member do
      post "activate"
      post "inactivate"
    end
    collection do
      get "reset"
    end
    resources :target_hostnames, :as => "hostnames",:only => [:index, :new, :create, :destroy]
  end
  resources :scripts do
    # Additional actions
    member do
      post "activate"
      post "inactivate"
    end
    collection do
      get "reset"
    end
    resources :script_category_assigns, :as => "category_assigns",:only => [:index, :new, :create, :destroy]
    resources :script_targets, :as => "targets",:only => [:index, :new, :create, :destroy]
  end

  # Root URL
  root :to => 'scripts#index'

  # See how all your routes lay out with "rake routes"
  
end
