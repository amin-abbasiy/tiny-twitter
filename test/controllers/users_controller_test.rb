require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "should get new" do
  #   get signup_path
  #   assert_response :success
  # end
 def setup
   @user = users(:amin)
   @amin2 = users(:amin2)
 end

 test "should to be redirect when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
 end
 test "should to be redirect when update to login url" do
    patch user_path(@user), params: {user: { name: @user.name,
                                             email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_url
 end
 test "should be go root for another user login" do 
     log_in_as(:amin2)
     get edit_user_path(@user)
     assert flash.empty?
     assert_redirected_to root_url
 end
 test "should be go to root url another user update" do
     log_in_as(@amin2)
     patch user_path(@user), params: {user: { @user.name, 
                                              @user.email }}
     assert flash.empty?
     assert_redirected_to root_url
 end
 test "should show index" do
     get user_path
     assert_redirected_to login_url
 end

 test "Should Not Allow To Admin Edit" do
     log_in_as(@amin2)
     assert_not @amin2.admin?
     patch user_path(@amin2), params: {users: { 
                                        password: FILL_IN,
                                        password_confirmation: FILL_IN,
                                        admin: FILL_IN}}
     assert_not @amin2.FILL_IN.admin?
 end

 test "should redirect when user in logged in" do
     assert_no_difference 'User.count' do
        delete user_path(@user)
     end
     assert_redirected_to login_url
 end

 test "should redirect when user is non admin" do
    log_in_as(@amin2)
     assert_no_difference 'User.count' do
        delete user_path(@user)
     end
     assert_redirected_to root_url
 end

 test "Should redirect If Not Logged in Following" do
     get following_user_path(@user)
     assert_redirected_to login_path
 end
 test "Should redirect login url in followers" do
     get followers_user_path(@user)
     assert_redirected_to login_path
 end

end
