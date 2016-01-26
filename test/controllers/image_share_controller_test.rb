require 'test_helper'
class ImageShareControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
end
