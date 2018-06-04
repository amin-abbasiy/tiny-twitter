require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
   def setup
    @user = users(:amin) 
    # @micropost = Micropost.new(content: "Leon Perfessional", user_id: @user.id)  
     #like top line
     @micropost = @user.microposts.build(content: "Leon Perfessional")
   end
   test "micropost should be valid" do
       assert @micropost.valid?
   end
   test "should be presence" do
      @micropost.user_id = nil
      assert_not @micropost.valid?
   end
   test "content should be presence" do
     @micropost.content = "   "
     assert_not @micropost.valid?
   end
   test "contyent should be less than 140 charachter" do
     @micropost.content = "a" * 141
     assert_not @micropost.valid?
   end
   test "order should be ali" do
      assert_equal @user.micropost(:amin), Micropost.first
   end
end
