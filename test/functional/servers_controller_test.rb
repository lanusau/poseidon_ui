require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign one of the fixtures to variable
    @server = server(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:servers)
    
    # Should have 2 rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do                
        server_count = Server.count
        assert_select "tr", server_count+1, "There should be #{server_count} rows in the list of servers"
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
        assert_select "input#server_name", 1, "Should have field for server name"
        assert_select "input#server_location", 1, "Should have field for server location"
        # One select list for status code
        assert_select "select", 1, "Should have one select in the form"
      end
    end
  end

  test "should create server" do
    assert_difference('Server.count') do
      post :create, server: { location: "somewhere", name: "Staging server", status_code: "A"}
    end

    assert_redirected_to servers_path
  end

  test "should get edit" do
    get :edit, id: @server
    assert_response :success
        # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do        
        # Input fields
        assert_select "input#server_name", 1, "Should have field for server name"
        assert_select "input#server_location", 1, "Should have field for server location"
        # One select list for status code
        assert_select "select", 1, "Should have one select in the form"
      end
    end
  end

  test "should update server" do
    put :update, id: @server, server: { location: @server.location, name: @server.name, status_code: @server.status_code }
    assert_redirected_to servers_path
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete :destroy, id: @server
    end

    assert_redirected_to servers_path
  end
end
