require 'test_helper'

class ScriptCategoriesControllerTest < ActionController::TestCase
  setup do
    # Assume we are logged in
    admin = User.find_by_login("admin")
    session[:user_id] = admin.id

    # Also, assign one of the fixtures to variable
    @script_category = script_category(:dba_related)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:script_categories)

    # Should have ScriptCategory.count rows in the table plus 1 header row
    assert_select "div.rowlist_page" do
      assert_select "table" do
        script_category_count = ScriptCategory.count
        assert_select "tr", script_category_count+1, "There should be #{script_category_count} rows in the list"
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
        assert_select "input#script_category_name", 1, "Should have field for script_category name"        
      end
    end
  end

  test "should create script_category" do
    assert_difference('ScriptCategory.count') do
      post :create, script_category: {
        name: "Postgres"
        }
    end

    assert_redirected_to script_categories_path
  end

  test "should get edit" do
    get :edit, id: @script_category
    assert_response :success
    # Should have form container div with form
    assert_select "div.form-container" do
      assert_select "form" do
        # Input fields
        assert_select "input#script_category_name", 1, "Should have field for script_category name"        
      end
    end
  end

  test "should update script_category" do
    put :update, id: @script_category, script_category: {
      name: @script_category.name
    }
    assert_redirected_to script_categories_path
  end

  test "should destroy script_category" do
    assert_difference('ScriptCategory.count', -1) do
      delete :destroy, id: @script_category
    end

    assert_redirected_to script_categories_path
  end
end
