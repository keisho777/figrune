require "test_helper"

class FiguresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get figures_index_url
    assert_response :success
  end
end
