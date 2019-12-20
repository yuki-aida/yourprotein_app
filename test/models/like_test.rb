require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @micropost = microposts(:van)
    # @like = @micropost.likes.create(user_id: @user)
    @like = Like.create(user_id: @user, micropost_id: @micropost)
  end
  
  test "should be valid" do
    assert_not @like.valid?
  end
  
  test "user_id should be present" do
    @like.user_id = nil
    assert_not @like.valid?
  end
  
  test "micropost_id should be present" do
    @like.micropost_id = nil
    assert_not @like.valid?
  end
  
  test "likes order should be most recent first" do
    # お気に入りテーブルが降順で並んでいるかを確かめる
    assert_equal likes(:one), Like.first
  end
  
end
