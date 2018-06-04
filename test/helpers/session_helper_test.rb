require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
     @user = users(:amin)
     remember(@user)
  end
  test "when session is nil" do
    assert_equal(@user, current_user)
    assert is_logged_in? 
  end
  test "Password DIgest Is Wrong" do
    @user.update_attribute(:remember_digest, User.digest(remember_token))
    assert_nil (current_user)
  end

end