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
    resources :scripts, :only => [:index]
  end
  resources :scripts do
    # Additional actions
    member do
      post "activate"
      post "inactivate"
      post "test_query"
      post "test_expression"
      get  "test_message"
    end
    collection do
      get "reset"
    end
    resources :script_category_assigns, :as => "category_assigns",:only => [:index, :new, :create, :destroy]
    resources :script_targets, :as => "targets",:only => [:index, :new, :create, :destroy]
    resources :script_groups, :as => "groups",:only => [:index, :new, :create, :destroy]
    resources :query_columns,:only => [:index, :create]
    resources :script_notifications, :as => "notifications",:only => [:index, :new, :create, :destroy]
    resources :script_person_notifications, :as => "person_notifications",:only => [:index, :new, :create, :destroy]
    resources :script_logs, :only => [:index]
  end
  resources :script_logs, :only => [:index] do
    collection do
      get "reset"
      get "filter"
    end
    resources :script_target_logs,:as => "target_logs", :only => [:index]
  end  
  resources :script_target_logs, :only => [] do
    resources :script_target_row_logs, :as => "row_logs", :only => [:index]
  end

  # Root URL
  root :to => 'scripts#index'

  # See how all your routes lay out with "rake routes"
  
end
