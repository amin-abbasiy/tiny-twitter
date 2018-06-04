require 'test_helper'

class UsersTestTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
      @user = user(:amin)
  end
  # test "login invalid and flash" do
  #    get login_path
  #    assert_template 'sessions/new'
  #    post login_path, params: {session: {email: '', password: ''}}
  #    assert_not flash.empty?
  #    assert_template 'session/new'
  #    get root_path
  #    assert flash.empty?
  #  end
   test "login page test" do
      get login_path    
        post params: { session: {email: @user.email , password: '123321'}}
       
        assert is_logged_in?

        assert_redirected_to @user
        follow_redirect!
        assert_template 'users/show'
        assert_select 'a[href=?]', login_path, count: 0
        assert_select 'a[href=?]', logout_path
        assert_select 'a[href=?]', current_user

        delete logout_path
        assert_not is_logged_in?
        assert_redirected_to root_url
        follow_redirect!
        assert_select "a[href=?]", login_path
        assert_select "a[href=?]", logout_path,      count: 0
        assert_select "a[href=?]", user_path(@user), count: 0
   end
   test "remember me" do
       log_in_as(@user, remember_me: '1')
       assert_not_empty cookies['remeber_token']
   end
   test "Not Remember me" do
      log_in_as(@user, remember_me: '1')
      log_in_as(@user, remember_me: '0')
      assert_empty cookies['remember_token']
   end
end