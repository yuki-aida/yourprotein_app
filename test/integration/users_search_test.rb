require 'test_helper'

class UsersSearchTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
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
  # 検索フォームに値を入力して送信
  
  # ユーザー一覧ページが表示されているか確認
  
  # 入力した値を含むユーザーがあるか確認
  
  # 入力した値を含まないユーザーが表示されていないか確認
  
  end
  
end
