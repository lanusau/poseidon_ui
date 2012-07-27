require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign one of the fixtures to variable
    @user = user(:lanusau)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)

    # Should have 3 rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        user_count = User.count
        assert_select "tr", user_count+1, "There should be #{user_count} rows in the list"
      end
    end
  end

  test "should render form for new" do
    get :new
    assert_response :success

    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#user_login", 1, "Should have field for user login"
        assert_select "input#user_password", 1, "Should have field for user password"
        assert_select "input#user_password_confirmation", 1, "Should have field for user password confirmation"
        # One select list for access_level
        assert_select "select", 1, "Should have one select in the form"
      end
    end
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {
        login: "test_user1",
        access_level: 1,
        password: "test123", password_confirmation: "test123"}
    end

    assert_redirected_to users_path
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
        # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#user_login", 1, "Should have field for user login"
        assert_select "input#user_password", 1, "Should have field for user password"
        assert_select "input#user_password_confirmation", 1, "Should have field for user password confirmation"
        # One select list for access_level
        assert_select "select", 1, "Should have one select in the form"
      end
    end
  end

  test "should update user" do
    put :update, id: @user, user: { login: @user.login, access_level: 0 }
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
