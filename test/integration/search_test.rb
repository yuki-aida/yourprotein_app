require 'test_helper'

class UsersSearchTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  # ユーザー一覧ページに対するテスト
  test "Users search" do
  # ログインする
  log_in_as(@user)
  # ユーザー一覧ページにアクセス
  get users_path
  # ユーザー一覧ページが表示されているか確認
  assert_template 'users/index'
  # 検索フォームがあることを確認
  assert_select "input[type=submit]"
  assert_select "input[type=search]"
  # 検索フォームに空の値を入力して送信
  get users_path, params: { search: "" }
  # ユーザー一覧ページが表示されているか確認
  assert_template 'users/index'
  assert_match @user.name, response.body
  assert_match @other_user.name, response.body
  # 検索フォームに値を入力して送信
  get users_path, params: { search: "Michael" }
  # ユーザー一覧ページが表示されているか確認
  assert_template 'users/index'
  # 入力した値を含むユーザーがあるか確認
  assert_match @user.name, response.body
  # 入力した値を含まないユーザーが表示されていないか確認
  assert_no_match @other_user.name, response.body
  end
  
  # マイクロポストフィードに対するテスト
  test "micropost feed search" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "input[type=submit]"
    assert_select "input[type=search]"
    get root_path, params: { search: "" }
    assert_template 'static_pages/home'
    assert_match "I just ate an orange!", response.body
    assert_match "Sad cats are sad: http://youtu.be/PKffm2uI4dk", response.body
    get root_path, params: { search: "I just ate an orange!" }
    assert_template 'static_pages/home'
    assert_match "I just ate an orange!", response.body
    assert_no_match "Sad cats are sad: http://youtu.be/PKffm2uI4dk", response.body
  end
  
  # # ユーザープロフィールページに対するテスト
  # test "users profile page micropost search" do
  #   log_in_as(@user)
  #   get user_path(@user)
  #   assert_template 'users/show'
  #   assert_select "input[type=submit]"
  #   assert_select "input[type=search]"
  #   get user_path(@user), params: { search: "" }
  #   assert_template 'users/show'
  #   assert_match "I just ate an orange!", response.body
  #   assert_match "Sad cats are sad: http://youtu.be/PKffm2uI4dk", response.body
  #   get user_path(@user), params: { search: "I just ate an orange!" }
  #   assert_template 'users/show'
  #   assert_match "I just ate an orange!", response.body
  #   assert_no_match "Sad cats are sad: http://youtu.be/PKffm2uI4dk", response.body
  # end
  
  # followingユーザーページに対するテスト
  test "following page users search" do
  log_in_as(@user)
  get following_user_path(@user)
  assert_template 'show_following'
  assert_select "input[type=submit]"
  assert_select "input[type=search]"
  get following_user_path(@user), params: { search: "" }
  assert_template 'show_following'
  assert_match "Lana Kane", response.body
  assert_match "Malory", response.body
  get following_user_path(@user), params: { search: "Lana Kane" }
  assert_template 'show_following'
  assert_match "Lana Kane", response.body
  assert_no_match "Malory", response.body
  end
  
  # followersユーザーページに対するテスト
  test "followers page users search" do
  log_in_as(@user)
  get followers_user_path(@user)
  assert_template 'show_followers'
  assert_select "input[type=submit]"
  assert_select "input[type=search]"
  get followers_user_path(@user), params: { search: "" }
  assert_template 'show_followers'
  assert_match "Sterling Archer", response.body
  assert_match "Lana", response.body
  get followers_user_path(@user), params: { search: "Sterling Archer" }
  assert_template 'show_followers'
  assert_match "Sterling Archer", response.body
  assert_no_match "Lana", response.body
  end
  
  # # お気に入り一覧に対するテスト
  # test "favorited posts search" do
  #   log_in_as(@user)
  #   get likes_user_path(@user)
  #   assert_template 'likes_users'
  #   get likes_user_path(@user), params: { search: "" }
  #   assert_template 'likes_users'
  #   assert_match "Oh, is that what you want? Because that's how you get ants!", response.body
  #   assert_match "Danger zone!", response.body
  #   get likes_user_path(@user), params: { search: "Oh, is that what you want? Because that's how you get ants!" }
  #   assert_template 'likes_users'
  #   assert_match "Oh, is that what you want? Because that's how you get ants!", response.body
  #   assert_no_match "Danger zone!", response.body
  # end
  
  # # プロテインカテゴリーに対するテスト
  # test "category protein search" do
  #   log_in_as(@user)
  #   get "/protein"
  #   assert_template 'category_posts'
  #   assert_select "input[type=submit]"
  #   assert_select "input[type=search]"
  #   get "/protein", params: { search: "" }
  #   assert_match "I just ate an orange!", response.body
  #   assert_match "Check out the @tauday site by @mhartl: http://tauday.com", response.body
  #   get "/protein", params: { search: "I just ate an orange!" }
  #   assert_template 'category_posts'
  #   assert_match "I just ate an orange!", response.body
  #   assert_no_match "Check out the @tauday site by @mhartl: http://tauday.com", response.body
  # end
  
  # # ウェアカテゴリーに対するテスト
  # test "category wear search" do
  #   log_in_as(@user)
  #   get '/wear'
  # end
  
  # # トレーニング用品に対するテスト
  # test "category training_items search" do
  #   log_in_as(@user)
  #   get '/training_items'
  # end
  
  # # その他カテゴリーに対するテスト
  # test "category others search" do
  #   log_in_as(@user)
  #   get '/others'
  # end
  
end
