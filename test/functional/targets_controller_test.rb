require 'test_helper'

class TargetsControllerTest < ActionController::TestCase

  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign one of the fixtures to variable
    @target = target(:target_one)
    @target_type = target_type(:oracle)
    @server = server(:production)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:targets)

    # Should have Target.count rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        target_count = Target.count
        assert_select "tr", target_count+1, "There should be #{target_count} rows in the list"
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
        assert_select "input#target_name", 1, "Should have field for target name"
        assert_select "input#target_hostname", 1, "Should have field for target hostname"
        assert_select "input#target_port_number", 1, "Should have field for target port_number"
        assert_select "input#target_database_name", 1, "Should have field for target database_name"
        assert_select "input#target_monitor_username", 1, "Should have field for target monitor_username"
        assert_select "input#target_monitor_password", 1, "Should have field for target monitor_password"
        assert_select "input#target_inactive_until", 1, "Should have field for target inactive_until"
        # Selects
        assert_select "select", 3, "Should have three select in the form"
      end
    end
  end

  test "should create target" do
    assert_difference('Target.count') do
      post :create, target: {
        server_id: @server.id,
        target_type_id: @target_type.id,
        name: "test@test4.com",
        hostname: "test4.com",
        port_number: 1521,
        database_name: "test",
        monitor_username: "app_monitor",
        monitor_password: "topsecrect",
        status_code: "A"
      }
    end

    assert_redirected_to targets_path
  end

  test "should get edit" do
    get :edit, id: @target
    assert_response :success
    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#target_name", 1, "Should have field for target name"
        assert_select "input#target_hostname", 1, "Should have field for target hostname"
        assert_select "input#target_port_number", 1, "Should have field for target port_number"
        assert_select "input#target_database_name", 1, "Should have field for target database_name"
        assert_select "input#target_monitor_username", 1, "Should have field for target monitor_username"
        assert_select "input#target_monitor_password", 1, "Should have field for target monitor_password"
        assert_select "input#target_inactive_until", 1, "Should have field for target inactive_until"
        # Selects
        assert_select "select", 3, "Should have three select in the form"
      end
    end
    # Should have iframe for hostname list
    assert_select "iframe#child_record_iframe", 1, "Should have an iframe for hostname list"
  end

  test "should update target" do
    put :update, id: @target, target: {
      status_code: "I",
      inactive_until: "01/01/2012 00:00:01"
    }
    assert_redirected_to targets_path
  end

  test "should destroy target" do
    assert_difference('Target.count', -1) do
      delete :destroy, id: @target
    end

    assert_redirected_to targets_path
  end
end
