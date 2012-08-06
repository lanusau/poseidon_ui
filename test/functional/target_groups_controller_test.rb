require 'test_helper'

class TargetGroupsControllerTest < ActionController::TestCase

  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign one of the fixtures to variable
    @target_group = target_group(:production_oracle)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:target_groups)

    # Should have TargetGroup.count rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        target_group_count = TargetGroup.count
        assert_select "tr", target_group_count+1, "There should be #{target_group_count} rows in the list"
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
        assert_select "input#target_group_name", 1, "Should have field for target_group name"
      end
    end
  end

  test "should create target_group" do
    assert_difference('TargetGroup.count') do
      post :create, target_group: {
        name: "Production Postgres"
        }
    end

    assert_redirected_to target_groups_path
  end

  test "should get edit" do
    get :edit, id: @target_group
    assert_response :success
    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#target_group_name", 1, "Should have field for target_group name"
      end
    end
  end

  test "should update target_group" do
    put :update, id: @target_group, target_group: {
      name: @target_group.name
    }
    assert_redirected_to target_groups_path
  end

  test "should destroy target_group" do
    assert_difference('TargetGroup.count', -1) do
      delete :destroy, id: @target_group
    end

    assert_redirected_to target_groups_path
  end
end
