require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
   def setup
      @user = users(:amin)
      log_in_as(@user)
      @other = users(:kaily)
   end

   test "follower page test" do
      get follower_user_path(@user)
      assert_not @user.followers.empty?
      assert_match @user.followers.count.to_s, response.body
      @user.followers.each do |user|
         assert_select "a[href=?]", user_path(user)
      end
   end

   test "following page test" do
      get following_user_path(@user)
      assert_not @user.following.empty?
      assert_match @user.following.count.to_s, response.body
      @user.following.each do |user|
         assert_select 'a[href=?]', user_path(user)
      end
   end
   test "follow test with ajax" do
      assert_difference "@user.following.count", 1 do
         post relationships_path, xhr: true, params: {followed_id: @other.id}
      end
   end
    
   test "follow standard way" do
      assert_difference "@user.following.count", 1 do
          post relationships_path, params: {followed_id: @other.id}
      end
   end

   test "unfollow test with ajax" do
      @user.follow(@other)
      relationship = @user.active_relatioships.find_by(followed_id: @other.id)
      assert_difference "@user.following.count", -1 do
          delete relationship_path(relationship), xhr: true
      end
   end

   test "Unfollow Since Standard Way" do
       @user.follow(@other)
       relationship = @user.active_relationships.find_by(followed_id: @other.id)
       assert_difference "@user.following.count", -1 do
           delete relationship_path(relationship)
       end
   end

   test "feed on Home page" do
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(FILL_IN), FILL_IN
    end
  end

end
