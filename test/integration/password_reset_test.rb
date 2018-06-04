require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  def setup
      @user = users(:amin)
  end
  test "Invalid Email Address" do
       get new_passwordreset_path
       assert_template 'passwordresets/new'
       #Invalid Email
       post passwordreset_path, params: {passwordreset: {email: ""}}
       assert_not flash.empty?
       assert_template 'passwordresets/new'
       #Valid Email
       post paaswordreset_path, params : {passwordreset: {email: @user.email}}
       assert_not_equal @user.reset_digest, @user.reload.reset_digest
       assert_equal 1,ActionMailer::Base.deliveries.size
       assert_not flash.empty?
       assert_redirected_to root_url
       #Password Reset Form
       user = assigns(@user)
       #Wrong Email
       get edit_passwordreset_path(user.reset_token, email: "")
       assert_redirected_to root_url 
       #Inactive User
       user.toggle!(:activated)
       get edit_passwordreset_path(user.reset_token, email: user.email)
       assert_redirected_to root_url
       user.toggle!(:activated)
       # Right email, wrong token
       get edit_passwordreset_path("wrong token", email: user.email)
       assert_redirected_to new_passwordreset_path
       #Right Email Right Token
       get edit_passwordreset_path(user.reset_token, email: user.email)
       assert_template 'passwordreset/edit'
       assert_select "input[name=email][type=hidden][value=?]", user.email
       # Invalid password & confirmation
       patch passwordreset_path(user.reset_token), 
                                params: {email: user.email,
                                         user: { password_digest: "123321",
                                                 password_confirmation: "321123"}}

       assert_select 'div#error_explanation'
       # Empty password
       patch passwordreset_path(user.reset_token),
                                params: {user.email,
                                         user: { password: "",
                                                 confirmation: ""}}
       assert_select 'div#error_explanation'
       #Valid Password And Confirmation
       patch passwordreset_path(user.reset_token),
                                params: {email: user.email,
                                         user: { password: "123321",
                                                 confirmation: "123321"}}
       assert is_logged_in?
       assert_not flash.empty?
       assert_redirected_to user
  end
end
