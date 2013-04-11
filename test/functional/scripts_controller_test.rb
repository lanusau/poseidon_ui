require 'test_helper'

class ScriptsControllerTest < ActionController::TestCase

  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign one of the fixtures to variable
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

  test "should reset session" do
    get :reset
    assert_nil(session[:page])
    assert_nil(session[:script_search_name])
    assert_nil(session[:script_category_id])
    assert_nil(session[:target_id])
    assert_nil(session[:target_group_id])

    assert_redirected_to scripts_path
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scripts)

    # Should have matching number of rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        script_count = Script.count
        assert_select "tr", script_count+1, "There should be #{script_count} rows in the list"
      end
    end
  end

  test "should get index by target_id" do
    target = target(:target_one)
    assert_routing "/targets/#{target.id}/scripts",
      { :controller => 'scripts', :action => "index", :target_id => target.id.to_s }
    get :index, :target_id => target.id
    assert_response :success
    assert_not_nil assigns(:scripts)

    # Should reset some session variables
    assert_nil(session[:script_category_id])
    assert_nil(session[:target_group_id])

    # Should have matching number of rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        script_count = target.script_targets.count
        assert_select "tr", script_count+1, "There should be #{script_count} rows in the list"
      end
    end
  end

  test "should get index by target_group_id" do
    target_group = target_group(:production_oracle)
    assert_routing "/target_groups/#{target_group.id}/scripts",
      { :controller => 'scripts', :action => "index", :target_group_id => target_group.id.to_s }
    get :index, :target_group_id => target_group.id
    assert_response :success
    assert_not_nil assigns(:scripts)

    # Should reset some session variables
    assert_nil(session[:script_category_id])
    assert_nil(session[:target_id])

    # Should have matching number of rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        script_count = target_group.script_groups.count
        assert_select "tr", script_count+1, "There should be #{script_count} rows in the list"
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
        assert_select "input#script_name", 1, "Should have field for script_name"
        assert_select "textarea#script_description", 1, "Should have textarea for target script_description"
      end
    end
  end

  test "should create record" do
    assert_difference('Script.count') do
      post :create, script: {
        name:  "Test",
        description: "Check query test functionality"
      }
    end

    new_script = Script.find_by_name("Test")
    assert_redirected_to edit_script_path(new_script)
  end

  test "should get edit" do
    get :edit, id: @script
    assert_response :success
    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#script_name", 1, "Should have field for script_name"
        assert_select "textarea#script_description", 1, "Should have textarea for tscript_description"
        assert_select "select#script_query_type", 1, "Should have select for script_query_type"
        assert_select "textarea#script_query_text", 1, "Should have textarea for script_query_text"
        assert_select "input#script_timeout_sec", 1, "Should have field for script_timeout_sec"
        assert_select "input#script_expression_text", 1, "Should have field for script_expression_text"
        assert_select "select#script_fixed_severity", 1, "Should have select for script_fixed_severity"
        assert_select "input#script_severity_column_position", 1, "Should have field for script_severity_column_position"
        assert_select "input#script_value_med_severity", 1, "Should have field for script_value_med_severity"
        assert_select "input#script_value_high_severity", 1, "Should have field for script_value_high_severity"
        assert_select "input#script_schedule_min", 1, "Should have field for script_schedule_min"
        assert_select "input#script_schedule_hour", 1, "Should have field for script_schedule_hour"
        assert_select "input#script_schedule_day", 1, "Should have field for script_schedule_day"
        assert_select "input#script_schedule_month", 1, "Should have field for script_schedule_month"
        assert_select "input#script_schedule_week", 1, "Should have field for script_schedule_week"
        assert_select "select#script_message_format", 1, "Should have select for script_message_format"
        assert_select "input#script_message_subject", 1, "Should have field for script_message_subject"
        assert_select "textarea#script_message_header", 1, "Should have textarea for script_message_header"
        assert_select "textarea#script_message_text_str", 1, "Should have textarea for script_message_text_str"
        assert_select "textarea#script_message_footer", 1, "Should have textarea for script_message_footer"
        assert_select "input#script_schedule_week", 1, "Should have field for script_schedule_week"
        assert_select "select#script_status_code", 1, "Should have select for script_status_code"
      end
    end
  end

  test "should update record" do
    put :update, id: @script, script: {
        name:  @script.name,
        description: "Check query test functionality",
        schedule_min: "0,30",
        schedule_hour: "*",
        schedule_day: "*",
        schedule_month: "*",
        schedule_week: "?",
        query_type: "1",
        query_text: "select * from psd_target",
        timeout_sec: "300",
        fixed_severity: "0",
        severity_column_position: "3",
        value_med_severity: "4",
        value_high_severity: "6",
        expression_text: "%3 > (%5+5) && %4 > 2",
        message_format: "0",
        message_subject: "[%t] Test",
        message_header: "",
        message_text_str: "Testing 123 ",
        message_footer: "",
        status_code: "A"
      }
    assert_redirected_to scripts_path
  end

  test "should destroy record" do
    assert_difference('Script.count', -1) do
      delete :destroy, id: @script
    end

    assert_redirected_to scripts_path
  end

  test "should activate script" do

    @script.status_code = 'I'
    @script.save

    post :activate, :id => @script, :format => 'js'
    assert_response :success

    # Reload record
    @script = Script.find(@script.id)
    assert_equal(@script.status_code, 'A')
  end

  test "should inactivate script" do

    @script.status_code = 'A'
    @script.save

    post :inactivate, :id => @script, :format => 'js'
    assert_response :success

    # Reload record    
    @script = Script.find(@script.id)
    assert_equal(@script.status_code, 'I')
  end

  test "should test script query" do
    post :test_query, :id => @script.id, :script => {
      :query_text => "select * from psd_script",
      :query_type => "1",
      :timeout_sec => "10"
    }

    assert_response :success
    assert_select "table.rowlist_table" do
      script_count = Script.count
      assert_select "tr", script_count+1, "There should be #{script_count} rows in the list"
    end
  end

  test "should test script expression" do
    post :test_expression, :id => @script.id, :script => {
      :query_text => "select * from psd_script",
      :query_type => "1",
      :timeout_sec => "10",
      :expression_text => "1 == 1"
    }

    assert_response :success
    assert_select "table.rowlist_table" do
      script_count = Script.count
      assert_select "tr", script_count+1, "There should be #{script_count} rows in the list"
    end
  end

  test "should test script message generation" do
    post :test_message, :id => @script.id, :script => {
      :query_text => "select * from psd_script",
      :query_type => "1",
      :timeout_sec => "10",
      :message_format => @script.message_format,
      :message_subject => @script.message_subject,
      :message_header => @script.message_header,
      :message_text_str => @script.message_text_str,
      :message_footer => @script.message_footer
    }

    assert_response :success
    assert_select "span.error_text",0, "There should be no error messages"
  end

  test "should render form for clone" do
    get :clone, id: @script
    assert_response :success

    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#script_name", 1, "Should have field for script_name"
        assert_select "textarea#script_description", 1, "Should have textarea for target script_description"
      end
    end
  end

  test "should clone script" do
    assert_difference('Script.count') do
      post :clone_create, id: @script, script: {
        name:  "Clone",
        description: "Create clone"
      }
    end

    new_script = Script.find_by_name("Clone")
    assert_redirected_to edit_script_path(new_script)
  end

end
