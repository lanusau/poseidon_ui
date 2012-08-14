require 'test_helper'

class QueryColumnsControllerTest < ActionController::TestCase
  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign some of the fixtures to variables
    @script = script(:query_test_script)

    # Update test target to have real values of the test database
    # We will use information stored in database.yml
    config = ActiveRecord::Base.configurations["test"]
    target = target(:test_target)
    target.hostname = config["host"]
    target.database_name = config["database"]
    target.monitor_username = config["username"]
    target.monitor_password = config["password"]
    target.save
    
  end

  test "should get index" do
    assert_routing "/scripts/#{@script.id}/query_columns",
      { :controller => 'query_columns', :action => "index",
        :script_id => @script.id.to_s }
    get :index, :script_id => @script.id
    assert_response :success
    assert_not_nil assigns(:script)
  end

  test "should populate new rows" do
    assert_routing({:method => 'post',:path=> "/scripts/#{@script.id}/query_columns"},
      { :controller => 'query_columns', :action => "create", :script_id => @script.id.to_s })

    # There are 13 columns in the query "select * from psd_target"
    assert_difference("Script.find(#{@script.id}).query_columns.size",+13) do
      post :create, :script_id => @script.id,
        :script => {
          :query_text => @script.query_text,
          :query_type => @script.query_type,
          :timeout_sec => @script.timeout_sec}
    end

    assert_response :success
    assert_not_nil assigns(:script)
  end
end
