require 'test_helper'

class PasswordresetsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get passwordresets_new_url
    assert_response :success
  end

  test "should get edit" do
    get passwordresets_edit_url
    assert_response :success
  end

end
