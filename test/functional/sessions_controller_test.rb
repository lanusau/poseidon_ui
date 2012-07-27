require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  setup do
    # Change routes to use password authentication
    PoseidonV3::Application.routes.draw do
      match 'login'  => 'sessions#new', :via => :get
      match 'login'  => 'sessions#create', :via => :post
      match 'logout' => 'sessions#destroy', :via => :delete
      root :to => 'servers#index'
    end    
  end

  def teardown
    PoseidonV3::Application.reload_routes!
  end

  test "Should render login form" do    
    get :new
    assert_response :success

    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # 2 fields and submit button
        assert_select "input", 3
      end
    end
  end

  test "Should login user" do
    post :create, {:login=>"admin",:password=>"test123"}
    assert_redirected_to root_url

    # Should also set session variable
    user = User.find_by_login("admin")
    assert_equal session[:user_id], user.id
    assert_equal 'Logged in!', flash[:notice]
  end

  test "Should not login user with bad password" do
    post :create, {:login=>"admin",:password=>"wrong"}

    # Instead of redirecting it should render login form again
    assert_response :success
    assert_equal 'Invalid login', flash[:error]

    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # 2 fields and submit button
        assert_select "input", 3, "Should have 3 elements in the login form"
      end
    end
  end

  test "Logout should clear session" do
    delete :destroy
    assert_redirected_to root_url
    assert_nil session[:user_id]
  end

end
