require 'test_helper'

class FavoriteTest < ActionDispatch::IntegrationTest
  # 前提としてmichaelはlanaとmaloryをフォローしている
  
  def setup
    @user = users(:michael)
    @other_user = users(:lana)
  end
  
  # マイクロポストフィード（ルートパス）に対するテスト
  test 'micropost feed favorite' do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    # フォローしているユーザーの投稿を確認
    @other_user.microposts.each do |post_following|
      assert @user.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    @user.microposts.each do |post_self|
      assert @user.feed.include?(post_self)
    end
    # いいねボタンがあるか確認
    assert_select "button[type=submit]"
    # michaelがlanaの最初の投稿をいいねする
    lana_micropost = @other_user.microposts.first.id
    assert_difference 'Like.count', 1 do
      post likes_path, params: { micropost_id: lana_micropost }
    end
    # いいねを解除する
    # lanaの最初の投稿のid
    # @other_userの最初の投稿に関連づけられていて、likeテーブルのuser_idが@userであるもの
    lana_like = Like.find_by(user_id: @user.id, micropost_id: @other_user.microposts.first.id).id
    assert_difference 'Like.count', -1 do
      delete like_path(lana_like)
    end
  end
  
end
