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


  # Root URL
  root :to => 'servers#index'

  # See how all your routes lay out with "rake routes"
  
end
