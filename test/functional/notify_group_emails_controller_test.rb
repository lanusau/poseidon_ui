require 'test_helper'

class NotifyGroupEmailsControllerTest < ActionController::TestCase

  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign some of the fixtures to variable
    @notify_group = notify_group(:dba)
    @notify_group_email = notify_group_email(:dba_severe)
  end

  test "should get index" do
    assert_routing '/notify_groups/1/notify_group_emails',
      { :controller => 'notify_group_emails', :action => "index", :notify_group_id => "1" }
    get :index, :notify_group_id=>@notify_group.id
    assert_response :success
    assert_not_nil assigns(:notify_group)
    assert_not_nil assigns(:notify_group_emails)

    # Should have matching number of rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        notify_group_email_count = @notify_group.notify_group_emails.count
        assert_select "tr", notify_group_email_count+1, "There should be #{notify_group_email_count} rows in the list"
      end
    end
  end

  test "should render form for new" do
    assert_routing '/notify_groups/1/notify_group_emails/new',
      { :controller => 'notify_group_emails', :action => "new", :notify_group_id => "1" }
    get :new, :notify_group_id => @notify_group.id
    assert_response :success

    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#notify_group_email_email", 1, "Should have field for notify_group_email email"
        # One select list for severity
        assert_select "select", 1, "Should have one select in the form"
      end
    end
  end

  test "should create notify_group_email" do
    assert_routing({:method => 'post',:path=> '/notify_groups/1/notify_group_emails'},
      { :controller => 'notify_group_emails', :action => "create", :notify_group_id => "1" })
    assert_difference('NotifyGroupEmail.count') do
      post :create, :notify_group_id => @notify_group.id,
        :notify_group_email =>{
          severity: 1,
          email: 'test@test.com'
        }
    end

    assert_redirected_to notify_group_emails_path(@notify_group)
  end

  test "should destroy notify_group_email" do
    assert_difference('NotifyGroupEmail.count', -1) do
      delete :destroy, id: @notify_group_email, notify_group_id: @notify_group.id
    end

    assert_redirected_to notify_group_emails_path(@notify_group)
  end
end
