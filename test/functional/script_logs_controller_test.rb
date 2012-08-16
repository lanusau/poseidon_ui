require 'test_helper'

class ScriptLogsControllerTest < ActionController::TestCase

  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id
  end

  test "should get index" do
    assert_routing "/script_logs",
      { :controller => 'script_logs', :action => "index" }
    get :index
    assert_response :success
    assert_not_nil assigns(:script_logs)

    # Should have same number of rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        record_cound = ScriptLog.count
        assert_select "tr", record_cound+1, "There should be #{record_cound} rows in the list"
      end
    end
  end

  test "should reset session" do
    assert_routing "/script_logs/reset",
      {:controller => 'script_logs', :action => 'reset'}
    get :reset
    assert_redirected_to script_logs_path
    assert_nil session[:script_logs_page]
    assert_nil session[:date_from]
    assert_nil session[:date_to]
    assert_nil session[:trigger_filter_code]
    assert_nil session[:error_filter_code]    
  end

  test "should reset page number" do
    assert_routing "/script_logs/filter",
      {:controller => 'script_logs', :action => 'filter'}
    get :filter, :trigger_filter_code => 1
    assert_redirected_to script_logs_path(:trigger_filter_code => 1)
    assert_nil session[:script_logs_page]
  end

  test "should display notice about invalid date format" do
    get :index, :date_from => "1/1/2001"
    assert_response :success
    assert_select "div.flash_note",1, "Should display notice about date format"
    get :index, :date_to => "1/1/2001"
    assert_response :success
    assert_select "div.flash_note",1, "Should display notice about date format"
  end
end
