require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "accont_activation" do
    user = users(:amin)
    user.activation_token = User.new_token
    mail = UserMailer.accont_activation
    assert_equal "Accont activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email). mail.body.encoded
  end

  test "password reset" do
    user = users(:amin)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "PasswordReset", mail.subject
    assert_equal ["noreplay@info.org"], mail.from
    assert_equal user.email, mail.to
    assert_match "Hi Dear Friend", mail.body.encoded
    assert_match User.reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

end
