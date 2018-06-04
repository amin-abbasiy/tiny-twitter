require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
ENV['RAILS_ENV'] ||= 'test'
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  def is_logged_in?
    !session[:user_id].nil?
  end
  def log_in_as(user, password: '123321', remember_me: '1')
    session[:user_id] = user.id
    login_path params: {session: { email: 'amiin@gmail.com',
                                    password: password,
                                    remember_me: remember_me}}
  end
  # Add more helper methods to be used by all tests here...
end
