require 'test_helper'

class UntdSessionsControllerTest < ActionController::TestCase

  setup do
    # Change routes to use SSO authentication
    PoseidonV3::Application.routes.draw do
      match 'login'  => 'untd_sessions#new', :via => :get
      match 'logout' => 'untd_sessions#destroy', :via => :delete
      root :to => 'servers#index'
    end
  end

  test "Should redirect to SSO server" do
    get :new
    assert_response :redirect
    assert_match(/auth.int.untd.com/, @response.header["Location"])
  end

  test "Should log user in based on sso_token" do
    get :new, :sso_token=>"lanusau|POSEIDON|1342737318|DKlzPPLE5ctWy0N0DMIl/lgU0izRZajXoOjfNhwQbQyIqBnbP+A+yVORo6sjyeDg nk5Efio4txB+Ppdp38IWWQ== "
    assert_redirected_to root_url

    # Should also set session variable
    user = User.find_by_login("lanusau")
    assert_equal session[:user_id], user.id
    assert_equal 'Logged in!', flash[:notice]
  end
end
