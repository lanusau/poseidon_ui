require 'test_helper'

class ScriptNotificationsControllerTest < ActionController::TestCase

  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign some of the fixtures to variable
    @script = script(:dataguard_check)
    @notify_group = notify_group(:ops_db)
    @script_notification = script_notification(:one)
  end

  test "should get index" do
    assert_routing "/scripts/#{@script.id}/script_notifications",
      { :controller => 'script_notifications', :action => "index", :script_id => @script.id.to_s }
    get :index, :script_id => @script.id
    assert_response :success
    assert_not_nil assigns(:script)

    # Should have matching number of rows
    assert_select "ul" do
      row_count = @script.script_notifications.count
      assert_select "li", row_count, "There should be #{row_count} rows in the list"
    end
  end

  test "should post new" do
    assert_routing "/scripts/#{@script.id}/script_notifications/new",
      { :controller => 'script_notifications', :action => "new", :script_id => @script.id.to_s }
    get :new, :script_id => @script.id, :format => 'js'
    assert_response :success
  end

  test "should create new record" do
    assert_routing({:method => 'post',:path=> "/scripts/#{@script.id}/script_notifications"},
      { :controller => 'script_notifications', :action => "create", :script_id => @script.id.to_s })
    assert_difference("Script.find(#{@script.id}).script_notifications.size") do
      post :create, :script_id => @script.id,
        :notify_group_id => @notify_group.id, :format => 'js'
    end

    assert_response :success
  end

  test "should destroy record" do
    assert_difference('ScriptNotification.count', -1) do
      delete :destroy, :id => @script_notification, :script_id => @script.id,:format => 'js'
    end

    assert_response :success

  end
end
