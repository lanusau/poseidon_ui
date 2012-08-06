require 'test_helper'

class TargetHostnamesControllerTest < ActionController::TestCase
  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, some one of the fixtures to variables
    @target_hostname = target_hostname(:target_one_host_one)
    @target = target(:target_one)
  end

  test "should get index" do
    assert_routing "/targets/#{@target.id}/target_hostnames",
      { :controller => 'target_hostnames', :action => "index", :target_id => @target.id.to_s }
    get :index, :target_id=>@target.id
    assert_response :success
    assert_not_nil assigns(:target)
    assert_not_nil assigns(:target_hostnames)

    # Should have matching number of rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        target_hostname_count = @target.target_hostnames.count
        assert_select "tr", target_hostname_count+1, "There should be #{target_hostname_count} rows in the list"
      end
    end
  end

  test "should render form for new" do
    assert_routing "/targets/#{@target.id}/target_hostnames/new",
      { :controller => 'target_hostnames', :action => "new", :target_id => @target.id.to_s }
    get :new, :target_id => @target.id
    assert_response :success

    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#target_hostname_hostname", 1, "Should have field for target_hostname hostname"
      end
    end
  end

  test "should create target_hostname" do
    assert_routing({:method => 'post',:path=> "/targets/#{@target.id}/target_hostnames"},
      { :controller => 'target_hostnames', :action => "create", :target_id => @target.id.to_s })
    assert_difference('TargetHostname.count') do
      post :create, :target_id => @target.id,
        :target_hostname =>{
          hostname: 'test4@test.com'
        }
    end

    assert_redirected_to target_hostnames_path(@target)
  end

  test "should destroy target_hostname" do
    assert_difference('TargetHostname.count', -1) do
      delete :destroy, id: @target_hostname, target_id: @target.id
    end

    assert_redirected_to target_hostnames_path(@target)
  end
end
