require "test_helper"

class Public::ListsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_lists_index_url
    assert_response :success
  end
end
