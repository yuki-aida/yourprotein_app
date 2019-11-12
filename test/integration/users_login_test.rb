require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "login with invalid information" do
  # ログイン用のパスを開く
    get login_path
  # 新しいセッションのフォームが正しく表示されたことを確認
    assert_template 'sessions/new'
  # わざと無効なparamsハッシュを使ってセッション用パスにpostする
    post login_path, params: { session: { email: "", password: "" } }
  # 新しいセッションのフォームが再度表示され、フラッシュメッセージが表示されたことを
  # 確認
    assert_template 'sessions/new'
    assert_not flash.empty?
  # 別のページに移動する
    get root_path
  # 移動先のページでフラッシュメッセージが表示されていないことを確認
    assert flash.empty?
  end
  
  test "login with valid information followed by logout" do
  # ログインフォームのパスを開く
    get login_path
  # セッション用パスに有効な情報をpostする
    post login_path, params: { session: { email: @user.email,
                                password: "password" } }
  # リダイレクト先が正しいか確認（実際にはまだ開いていない）
    assert_redirected_to @user
  # ログイン済みか確認
    assert is_logged_in?
  # そのページ（ユーザー詳細ページ）に実際に移動
    follow_redirect!
  # ユーザーページが正しく描写されているか確認
    assert_template 'users/show'
  # ログイン用レイアウトが表示されなくなったか確認
  # 引数にcount: 0を追加すると一致するリンクがないかどうか確認できる
    assert_select "a[href=?]", login_path, count: 0 
  # ログアウト用レイアウトが表示されているか確認
    assert_select "a[href=?]", logout_path
  # ユーザー詳細ページへのリンクが表示されているか確認
    assert_select "a[href=?]", user_path(@user)
  # ログアウトする
    delete logout_path
  # ログアウトできたか確認
    assert_not is_logged_in?
  # リダイレクト先が正しいか確認(root_url)
    assert_redirected_to root_url
  # 2番目のウィンドウでログアウトするユーザーを想定
    delete logout_path
  # 実際にリダイレクトする
    follow_redirect!
  # ログインパスがあるか確認
    assert_select "a[href=?]", login_path
  # ログアウトパスがないか確認
    assert_select "a[href=?]", logout_path, count: 0
  # ユーザー詳細ページがないか確認
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: "1")
    # 記憶トークンが空でないか確認
    # 元のコード assert_not_empty cookies['remember_token']
    # assignsという特殊なメソッドを使うとコントローラーで定義したインスタンス変数に
    # テスト内部からアクセスすることができる
    assert_equal cookies['remember_token'], assigns[:user].remember_token
  end
  
  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: "1")
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: "0")
    assert_empty cookies['remember_token']
  end
end
