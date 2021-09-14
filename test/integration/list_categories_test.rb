require "test_helper"

class ListCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @category_one = Category.create(name: "Fiction")
    @category_two = Category.create(name: "Fable")
  end

  test "should show category listing" do
    get "/categories"
    assert_select "a[href=?]", category_path(@category_one), text: @category_one.name
    assert_select "a[href=?]", category_path(@category_two), text: @category_two.name
  end

end
