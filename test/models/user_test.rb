require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: 'Amin', email: 'Amin@gmail.com',
                     password: 'pass', password_confirmation: 'pass')
  end

  test "sould be valid" do
      assert @user.valid?
  end

  test "name should be presence" do
     @user.name = "    "
     assert_not @user.valid?
  end

  test "email should be presence" do
    @user.email = "   "
    assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.email = "b" * 244 + "@example.com"
    assert_not @user.valid?
  end
  test "Email Exact Format" do
     valid_adresses = %w[amin@gmail.com best@yahoo.com fine@live.com]
     valid_adresses.each do |valid_address|
          @user.email = valid_address
          assert @user.valid?, "#{valid_address.inspect} Have To Be Valid Format"
     end
  end
  test "user should to be unique" do
     dup = @user
     if dup.email != @user.email.upcase then
     @user.save
     end
     assert dup.valid?
     
    end
    test "email shuold to be dancase" do
        edwn_case = "AmiN@GMAil.CoM"
        @user.email = edwn_case
        @user.save
        assert_equal(edwn_case.downcase, @user.reload.email)
    end
    test "password should be nonblank" do
       @user.password = @user.password_confirmation = " " * 6
       assert_not @user.valid?
    end
    test "minimum length for password" do
       @user.password = @user.password_confirmation = " " * 5
       assert_not @user.valid?
    end
    test "autonticated test" do
        assert_not @user.autonticated(:remeber, '')
    end
    test "associated micropost should be delete" do
       @user.save
       @user.microposts.create!("Leon Perfessional")
       assert_difference("Micropost.count", -1) do
          @user.destroy
       end
    end
    test "for follow and unfollow user" do
       amin = users(:amin)
       amin2 = users(:amin2)
       assert_not amin.following?(amin2)
       amin.follow(amin2)
       assert amin.following?(amin2)
       assert amin2.followers.include?(amin)
       amin.unfollow(amin2)
       assert_not amin.following(amin2)
    end
    test "Feed For Right Posts" do
        amin = users(:amin)
        amin2 = users(:amin2)
        kaily = users(:kaily)

        #Followed User Posts
        kaily.microposts.each do |followed_posts|
           assert amin.feed.include?(followed_posts)
        end

        amin.microposts.each do |self_posts|
           assert amin.feed.include?(self_posts)
        end

        amin2.microposts.each do |unfollowed_posts|
           assert_not amin.feed.include?(unfollowed_posts)
        end
    end
end
