require 'test_helper'

class ScriptTargetsControllerTest < ActionController::TestCase
  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign some of the fixtures to variable
    @script = script(:dataguard_check)
    @target = target(:target_two)
    @script_target = script_target(:one)
  end

  test "should get index" do
    assert_routing "/scripts/#{@script.id}/script_targets",
      { :controller => 'script_targets', :action => "index", :script_id => @script.id.to_s }
    get :index, :script_id => @script.id
    assert_response :success
    assert_not_nil assigns(:script)

    # Should have matching number of rows
    assert_select "ul" do
      row_count = @script.script_targets.count
      assert_select "li", row_count, "There should be #{row_count} rows in the list"
    end
  end

  test "should post new" do
    assert_routing "/scripts/#{@script.id}/script_targets/new",
      { :controller => 'script_targets', :action => "new", :script_id => @script.id.to_s }
    xhr :get, :new, :script_id => @script.id, :format => 'js'
    assert_response :success
  end

  test "should create new record" do
    assert_routing({:method => 'post',:path=> "/scripts/#{@script.id}/script_targets"},
      { :controller => 'script_targets', :action => "create", :script_id => @script.id.to_s })
    assert_difference("Script.find(#{@script.id}).script_targets.size") do
      post :create, :script_id => @script.id,
        :target_id => @target.id, :format => 'js'
    end

    assert_response :success
  end

  test "should destroy record" do
    assert_difference('ScriptTarget.count', -1) do
      delete :destroy, :id => @script_target, :script_id => @script.id,:format => 'js'
    end

    assert_response :success

  end
end
