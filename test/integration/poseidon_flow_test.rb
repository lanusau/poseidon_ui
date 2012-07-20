require 'test_helper'

class PoseidonFlowTest < ActionDispatch::IntegrationTest
  fixtures :server,:user

  test "login and browse site using password authentication" do

    # Change routes to use password authentication
    PoseidonV3::Application.routes.draw do
      match 'login'  => 'sessions#new', :via => :get
      match 'login'  => 'sessions#create', :via => :post
      match 'logout' => 'sessions#destroy', :via => :delete
      resources :servers
      root :to => 'servers#index'
    end

    get "/login"
    assert_response :success

    # Login as admin user
    post_via_redirect "/login", :login => "admin", :password => "test123"    
    assert_equal "/", path
    assert_equal 'Logged in!', flash[:notice]

    get "/servers"
    assert_response :success
    assert assigns(:servers)
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
    get_via_redirect "/login", :sso_token=>"lanusau|POSEIDON|1342737318|DKlzPPLE5ctWy0N0DMIl/lgU0izRZajXoOjfNhwQbQyIqBnbP+A+yVORo6sjyeDg nk5Efio4txB+Ppdp38IWWQ== "
    assert_equal "/", path
    assert_equal 'Logged in!', flash[:notice]

    get "/servers"
    assert_response :success
    assert assigns(:servers)
  end  

end
