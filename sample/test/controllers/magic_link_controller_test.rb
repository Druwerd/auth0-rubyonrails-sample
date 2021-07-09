require "test_helper"

class MagicLinkControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get magic_link_new_url
    assert_response :success
  end

  test "should get send" do
    get magic_link_send_url
    assert_response :success
  end
end
