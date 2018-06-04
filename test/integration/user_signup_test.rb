require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
     ActionMailer::Base.deliveries.clear
  end
   test "user is invalid" do
      get signup_path
      assert_no_difference "User.count" do 
        post users_path, params: { user: { name: 'amp',
                                           email: 'dsew@invalid',
                                           password: '123',
                                           password_confimation: '4562'} }
      end
      assert_equal 1, ActionMailer::Base.deliveries.size
      user = assign(:user)
      assert_not user.activated?
      #Unactivated Acoont
      log_in_as(user)
      assert_not is_logged_in(user)
      #Invalid Token
      get edit_accont_activations_path("Invalid Token", email: user.email)
      assert_not is_logged_in
      #Wrong Email
      get edit_accont_activations_path(user.activation_token, email: "Wrong Mail")
      assert_not is_logged_in?
      #Valid Incformation
      get edit_accont_activations_path(user.activation_token, email: user.email)
      assert(user_reload_activated?)
      follow_redirect!
      assert_template 'users/show'
      assert is_logged_in?
   end
   test "valid signup information" do
     get signup_path
     assert_difference "User.count" do
        post users_path, params: {user: { name: 'amin',
                                   email: 'vaid@gmail.com',
                                   password: 'passcode',
                                  password_confirmation: 'passcode'} }
     end
     follow_redirect!
     assert_template 'users/show'
     assert is_logged_in?
   end
end
