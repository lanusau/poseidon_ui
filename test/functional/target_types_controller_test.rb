require 'test_helper'

class TargetTypesControllerTest < ActionController::TestCase
  
  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign one of the fixtures to variable
    @target_type = target_type(:oracle)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:target_types)

    # Should have TargetType.count rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        target_type_count = TargetType.count
        assert_select "tr", target_type_count+1, "There should be #{target_type_count} rows in the list"
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
        assert_select "input#target_type_name", 1, "Should have field for target_type name"
        assert_select "input#target_type_url_ruby", 1, "Should have field for target_type url_ruby"
        assert_select "input#target_type_url_jdbc", 1, "Should have field for target_type url_jdbc"
      end
    end
  end

  test "should create target_type" do
    assert_difference('TargetType.count') do
      post :create, target_type: {
        name: "Postgres",
        url_ruby: "dbi:Pg:dbname=%d;host=%h;port=%p",
        url_jdbc: "jdbc:postgresql://%h:%p/%d"
        }
    end

    assert_redirected_to target_types_path
  end

  test "should get edit" do
    get :edit, id: @target_type
    assert_response :success
    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#target_type_name", 1, "Should have field for target_type name"
        assert_select "input#target_type_url_ruby", 1, "Should have field for target_type url_ruby"
        assert_select "input#target_type_url_jdbc", 1, "Should have field for target_type url_jdbc"
      end
    end
  end

  test "should update target_type" do
    put :update, id: @target_type, target_type: {
      name: @target_type.name,
      url_ruby: @target_type.url_ruby,
      url_jdbc: @target_type.url_jdbc
    }
    assert_redirected_to target_types_path
  end

  test "should destroy target_type" do
    assert_difference('TargetType.count', -1) do
      delete :destroy, id: @target_type
    end

    assert_redirected_to target_types_path
  end
end
