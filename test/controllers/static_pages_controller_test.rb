require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  # test 'About Should To Be Success' do
  #   get static_pages_about_url
  #   assert_response :success
  # end

  # test StaticPagesControllerTest do
  #   get static_pages_hello_url
  #   assert_response :success
  # end
  def setup
  	@base_title = "Home | AMin Is Best"
  end
  # test "shuold get root" do
  #    get FILL_IN
  #    assert_response FILL_IN
  # end
  

  # test "home should be" do
  # 	 get static_pages_home_url
  # 	 assert_response :success
  # 	 assert_select "title", "Home | AMin IS Best"
  # end

end
