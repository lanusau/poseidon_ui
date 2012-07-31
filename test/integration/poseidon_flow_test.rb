require 'test_helper'

class PoseidonFlowTest < ActionDispatch::IntegrationTest
  fixtures :server,:user,:target_type

  test "login and browse site using password authentication" do

    # Change routes to use password authentication
    PoseidonV3::Application.routes.draw do
      match 'login'  => 'sessions#new', :via => :get
      match 'login'  => 'sessions#create', :via => :post
      match 'logout' => 'sessions#destroy', :via => :delete
      root :to => 'servers#index'
    end

    get "/login"
    assert_response :success

    # Login as admin user
    post "/login", :login => "admin", :password => "test123"
    assert_redirected_to root_url
    assert_not_nil session[:user_id]
    assert_equal 'Logged in!', flash[:notice]

    # Reload routes to continue testing
    PoseidonV3::Application.reload_routes!

    # Check list of servers
    get "/servers"
    assert_response :success
    assert assigns(:servers)

    # Check list of target types
    get "/target_types"
    assert_response :success
    assert assigns(:target_types)
    
  end

  test "login and browse site using SSO authentication" do

    # Change routes to use password authentication
    PoseidonV3::Application.routes.draw do
      match 'login'  => 'untd_sessions#new', :via => :get
      match 'logout' => 'untd_sessions#destroy', :via => :delete
      resources :servers
      root :to => 'servers#index'
    end

    # Login as SSO user    
    get "/login", :sso_token=>"lanusau|POSEIDON|1342737318|DKlzPPLE5ctWy0N0DMIl/lgU0izRZajXoOjfNhwQbQyIqBnbP+A+yVORo6sjyeDg nk5Efio4txB+Ppdp38IWWQ== "
    assert_redirected_to root_url
    assert_not_nil session[:user_id]
    assert_equal 'Logged in!', flash[:notice]

    # Reload routes to continue testing
    PoseidonV3::Application.reload_routes!

    # Check list of servers
    get "/servers"
    assert_response :success
    assert assigns(:servers)

    # Check list of target types
    get "/target_types"
    assert_response :success
    assert assigns(:target_types)

  end  

end
