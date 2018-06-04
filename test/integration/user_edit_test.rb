require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
   def setup
      @user = users(:amin)
   end
   test "Unsuccessful Edit" do
      get edit_user_path(@user)
      log_in_as(@user)
      assert_redirected_to edit_user_url(@user)

     


      get edit_new_path
      assert_template 'user/edit'
      patch user_path(@user), params: { user: { name: '',
                                      email: 'aminwq@gmail.com',
                                      password: 'foo',
                                      password_confirmation: 'bar'}}
      assert_template 'user/edit' 
   end
   test "Successful Edits" do
      log_in_as(@user)
      get edit_user_path
      assert_template 'user/edit'
      name = "amin"
      email = "amiin@gmail.com"
      patch user_path(@user), params: {user: {name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: ''}}
      assert_not flash.empty?
      assert_redirected_to 'user/show'
      @user.reload
      assert_equal name, @user.name
      assert_equal email, @user.email                                        
   end
end
