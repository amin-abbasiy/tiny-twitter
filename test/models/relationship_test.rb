require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:amin).id,
                                     followed_id: users(:amin2).id)
  end

  test "valid follow" do
     assert @relationship.valid?
  end
  test "invalid follower_id" do
     @relationship.follower_id = nil
     assert_not @relationship.valid?
  end
  test "invalid followed_id" do
     @relationship.followed_id = nil
     assert_not @relationship.valid?
  end
end
