require 'test_helper'

class UsersSearchTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
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
    get root_path, params: { search: "I just ate an orange!" }
    assert_template 'static_pages/home'
    assert_match "I just ate an orange!", response.body
    assert_no_match "Sad cats are sad: http://youtu.be/PKffm2uI4dk", response.body
  end
  
  # ユーザープロフィールページに対するテスト
  test "users profile page micropost search" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select "input[type=submit]"
    assert_select "input[type=search]"
    get user_path(@user), params: { search: "" }
    assert_template 'users/show'
    get user_path(@user), params: { search: "I just ate an orange!" }
    assert_template 'users/show'
    assert_match "I just ate an orange!", response.body
    assert_no_match "Sad cats are sad: http://youtu.be/PKffm2uI4dk", response.body
  end
  
  # followingユーザーページに対するテスト
  test "following page users search" do
  log_in_as(@user)
  get following_user_path(@user)
  assert_template 'show_following'
  assert_select "input[type=submit]"
  assert_select "input[type=search]"
  get following_user_path(@user), params: { search: "" }
  assert_template 'show_following'
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
  get followers_user_path(@user), params: { search: "Sterling Archer" }
  assert_template 'show_followers'
  assert_match "Sterling Archer", response.body
  assert_no_match "Malory", response.body
  end
  
end
