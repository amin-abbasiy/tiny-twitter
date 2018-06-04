require 'test_helper'

class MicropostIntefaceTest < ActionDispatch::IntegrationTest
   def setup
      @user = users(:amin)
   end

   test "micropost instructions commands" do
       log_in_as(@user)
       get root_path
       assert_select 'div.pagination'
       assert_select 'input[type=file]'
       #Invalid Submit
       assert_no_difference "Micropost.count" do
          post micro_posts_path, params: {:content => "  "}
       end
       assert_select "div#error_explanation"
       #Valid Submit
       content = "Amin Received"
       picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
       assert_difference "Micropost.count", 1 do
          post micro_post_path, params: {content: content, picture: picture}
       end
       assert picture.picture?
       assert_redirected_to root_url
       follow_redirect!
       assert_match content, response.body
       #Delete
       assert_select 'a', text: :Delete
       first_micropost=@user.microposts.paginate(page: 1).first
       assert_difference "Micropost.count", -1 do
          delete micro_post_path(first_micropost)
       end
       assert_redirected_to root_url
       #Showing Another User Delete Button
       get user_path(users(:another))
       assert_select 'a', text: :Delete, count: 0
   end
   test "Micropost Sidbar Count" do
      log_in_as(@user)
      get root_path
      assert_match "#{How many Micropost(amin----)} micropost", response.body
      @other_user = users(:mia)
      log_in_as(@other_user)
      get root_path
      assert_match "0 micropost", response.body
      @other_user.microposts.create!(:content => "Amin Advanced")
      get root_path
      assert_match "1 micropost", response.body
   end
end
