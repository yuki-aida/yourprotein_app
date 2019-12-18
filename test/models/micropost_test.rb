require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum", title: "aaaaa",
                          category: "その他")
  end
  
  test "should be valid" do
    assert @micropost.valid?
  end
  
  test "user_id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end
  
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 401
    assert_not @micropost.valid?
  end
  
  test "order should be most recent first" do
    # データベース上の最初のマイクロポストが、fixture内のマイクロポスト (most_recent) と同じ
    # か確かめる
    assert_equal microposts(:most_recent), Micropost.first
  end
  
end
