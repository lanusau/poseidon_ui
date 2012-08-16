require 'test_helper'

class ScriptTargetLogsControllerTest < ActionController::TestCase

  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id
  end

  test "should get index" do
    script_log = script_log(:dataguard_check_log_one)
    assert_routing "/script_logs/#{script_log.id}/script_target_logs",
      { :controller => 'script_target_logs', :action => "index", :script_log_id => script_log.id.to_s }
    get :index, :script_log_id => script_log.id
    assert_response :success
    assert_not_nil assigns(:script_log)

    # Should have same number of rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        record_cound = script_log.script_target_logs.count
        assert_select "tr", record_cound+1, "There should be #{record_cound} rows in the list"
      end
    end
  end
end
