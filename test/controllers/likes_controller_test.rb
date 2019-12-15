require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Like.count' do
      post likes_path, params: { micropost_id: @user.microposts.first.id }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Like.count' do
      delete like_path(@user.microposts.first.id)
    end
    assert_redirected_to login_url
  end
  
end
