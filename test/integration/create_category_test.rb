require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create(username: "admin", email: "admin@example.com", password: "admin", is_admin: true)
    login_as(@admin)
  end

  test "get new category form and create" do
    get "/categories/new"
    assert_response :success
    assert_difference 'Category.count', 1 do 
      post categories_path, params: { category: { name: "myth" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "myth", response.body
  end

  test "get new category form and reject invalid submission" do
    get "/categories/new"
    assert_response :success
    assert_no_difference 'Category.count' do 
      post categories_path, params: { category: { name: " " } }
    end
    assert_match "error", response.body
    assert_select 'div.alert'
    assert_select 'h5.alert-heading'
  end

end
