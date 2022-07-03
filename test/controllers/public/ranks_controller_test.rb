require "test_helper"

class Public::RanksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_ranks_new_url
    assert_response :success
  end
end
