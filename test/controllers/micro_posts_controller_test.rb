require 'test_helper'

class MicroPostsControllerTest < ActionDispatch::IntegrationTest
    def setup
       @user = users(:orang)
    end

    test "redirect in create if not logged in user" do
       assert_no_difference "Micropost.count" do
          post micro_posts_path, params: {micropost: {content: "Amin Is Great"}}
       end
       assert_redirected_to login_url
    end

    test "redirect in destroy action if not loggend In" do
        assert_no_difference "Micropost.count" do
           delete micro_post_path(@micropost)
        end
        assert_redirected_to login_url
    end
    test "should to redirect root url wrong user" do
        log_in_as(users(:amin))
        micropost = microposts(:orang)
        assert_no_defference "Micropost.count" do
           delete micro_post_path(micropost)
        end
        assert_redirected_to(root_url)
    end


end
