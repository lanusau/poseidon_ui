require 'test_helper'

class NotifyGroupsControllerTest < ActionController::TestCase

  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign one of the fixtures to variable
    @notify_group = notify_group(:dba)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notify_groups)

    # Should have NotifyGroup.count rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        notify_group_count = NotifyGroup.count
        assert_select "tr", notify_group_count+1, "There should be #{notify_group_count} rows in the list"
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
        assert_select "input#notify_group_name", 1, "Should have field for notify_group name"
      end
    end
  end

  test "should create notify_group" do
    assert_difference('NotifyGroup.count') do
      post :create, notify_group: {
        name: "Bs-Ops"
        }
    end

    assert_redirected_to notify_groups_path
  end

  test "should get edit" do
    get :edit, id: @notify_group
    assert_response :success
    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#notify_group_name", 1, "Should have field for notify_group name"
      end
    end
  end

  test "should update notify_group" do
    put :update, id: @notify_group, notify_group: {
      name: @notify_group.name
    }
    assert_redirected_to notify_groups_path
  end

  test "should destroy notify_group" do
    assert_difference('NotifyGroup.count', -1) do
      delete :destroy, id: @notify_group
    end

    assert_redirected_to notify_groups_path
  end
end
