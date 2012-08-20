require 'test_helper'

class TargetGroupAssignmentsControllerTest < ActionController::TestCase
  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Assign some fixtures to variables
    @target = target(:target_one)
    @target_group = target_group(:production_oracle)
    @target_group_assignment = target_group_assignment(:one)
  end

  test "should get index querying by target" do
    assert_routing "/targets/#{@target.id}/target_group_assignments",
      { :controller => 'target_group_assignments', :action => "index", :target_id => @target.id.to_s }
    get :index, :target_id => @target.id
    assert_response :success
    assert_not_nil assigns(:target)
    assert_not_nil assigns(:target_groups)

    assert_select "table.rowlist_table" do

      # Should have all target groups in the list +1 row for header
      row_count = TargetGroup.count + 1
      assert_select "tr", row_count,
        "There should be #{row_count} total rows in the list"

      # But only groups assigned to the target should have check image
      image_count = @target.target_group_assignments.count      
      assert_select 'img[src=/assets/check.png]', image_count,
        "There should be #{image_count} check images in the list"
    end
  end

  test "Should assign target to a new group" do
    assert_routing "/targets/#{@target.id}/target_group_assignments/toggle",
      { :controller => 'target_group_assignments', :action => "toggle", :target_id => @target.id.to_s }
    new_target_group = target_group(:production_mysql)

    # Toggle on
    assert_difference("Target.find(#{@target.id}).target_group_assignments.size") do
      get :toggle, :target_id => @target.id, :target_group_id => new_target_group.id,:format => 'js'
    end
    assert_response :success
    
    # Toggle off
    assert_difference("Target.find(#{@target.id}).target_group_assignments.size",-1) do
      get :toggle, :target_id => @target.id, :target_group_id => new_target_group.id,:format => 'js'
    end
    assert_response :success
    
  end

  test "should get index querying by group" do
    assert_routing "/target_groups/#{@target_group.id}/target_group_assignments",
      { :controller => 'target_group_assignments', :action => "index", :target_group_id => @target_group.id.to_s }
    get :index, :target_group_id => @target_group.id
    assert_response :success
    assert_not_nil assigns(:target_group)
    assert_not_nil assigns(:available_targets)

    assigned_target_count = @target_group.target_group_assignments.count
    assert_select "div#targets_in_group_list table" do

      # Should have the same amount of rows in the list +1 row for header      
      assert_select "tr", assigned_target_count + 1,
        "There should be #{assigned_target_count} total rows in the list"

    end

    # There should also be a div for available targets
    assert_select "div.list-page" do
      
      # The number of rows in this page should be number of targets minus
      # number of assigned targets      
      num_available_targets = Target.count - assigned_target_count
      assert_select "tr[class=?]", /even|odd/ ,num_available_targets,
        "There should be #{num_available_targets} rows in the list of available targets"
    end
  end

  test "should activate target assignment" do
    assert_routing({:method => 'post',:path=> "/target_groups/#{@target_group.id}/target_group_assignments/#{@target_group_assignment.id}/activate"},
      { :controller => 'target_group_assignments', :action => "activate",
        :target_group_id => @target_group.id.to_s, :id => @target_group_assignment.id.to_s })
    @target_group_assignment.status_code='I'
    @target_group_assignment.save
    post :activate,  :target_group_id => @target_group.id,
         :id => @target_group_assignment.id,:format => 'js'
    assert_response :success
    @target_group_assignment.reload
    assert_equal('A',@target_group_assignment.status_code)
  end

  test "should inctivate target assignment" do
    assert_routing({:method => 'post',:path=> "/target_groups/#{@target_group.id}/target_group_assignments/#{@target_group_assignment.id}/inactivate"},
      { :controller => 'target_group_assignments', :action => "inactivate",
        :target_group_id => @target_group.id.to_s, :id => @target_group_assignment.id.to_s })
    @target_group_assignment.status_code='A'
    @target_group_assignment.save
    post :inactivate,  :target_group_id => @target_group.id,
         :id => @target_group_assignment.id,:format => 'js'
    assert_response :success
    @target_group_assignment.reload
    assert_equal('I',@target_group_assignment.status_code)
  end

  test "should create new target assignment" do
    assert_routing({:method => 'post',:path=> "/target_groups/#{@target_group.id}/target_group_assignments"},
      { :controller => 'target_group_assignments', :action => "create",
        :target_group_id => @target_group.id.to_s})
    new_target = target(:target_two)
    assert_difference("TargetGroup.find(#{@target_group.id}).target_group_assignments.size") do
      post :create, :target_group_id => @target_group.id, :target_id =>new_target.id,
         :format => 'js'
    end
    assert_response :success
  end
  test "should destroy target assignment" do
    assert_routing({:method => 'delete',
                    :path=> "/target_groups/#{@target_group.id}/target_group_assignments/#{@target_group_assignment.id}"},
      { :controller => 'target_group_assignments', :action => "destroy",
        :target_group_id => @target_group.id.to_s,:id => @target_group_assignment.id.to_s})
    assert_difference("TargetGroup.find(#{@target_group.id}).target_group_assignments.size",-1) do
      delete :destroy, :target_group_id => @target_group.id, :id =>@target_group_assignment.id,
         :format => 'js'
    end
    assert_response :success
  end  
end
