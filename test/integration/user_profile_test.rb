require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper #For gain access
   def setup
      @user = users(:amin)
   end

   test "Profiel Display" do
      get user_path(@user)
      assert_template 'users/show'
      assert_select 'title', full_title(@user.name)
      assert_select 'h1', @user.name
      assert_select 'h1>img.garavatar'
      assert_match microposts.count.to_s, response.body
      assert_select 'dev/pagination'
      @user.microposts.paginate(page: 1).each do |micropost|
         assert_match micropost.content, response.body
      end
   end
   
end
