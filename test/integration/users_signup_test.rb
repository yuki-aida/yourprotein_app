require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    # 変数deliveriesを初期化
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    # 無効なユーザーを登録して、データベースのユーザーの数が変わっていないことをテスト
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {name: "",email: "",
                      password: "foo", password_confirmation: "bar" } }
    end
    # users/newページにレンダリングされているかテスト
    assert_template 'users/new'
    # <div id = "error_explanation"></div>というHTMLがあるかどうかテスト
    assert_select 'div#error_explanation'
    # <div class = "alert"></div>というHTMLがあるかどうかテスト
    assert_select 'div.alert'
    # 'form[action="/signup"]'というHTMLがあるかどうかテスト
    assert_select 'form[action="/signup"]'
  end
  
  test "valid signup information with account activation" do
    get signup_path
    # assert_differenceブロック内の処理を実行する直前のUser.countの値と実行した後の
    # 値を比較
    picture = fixture_file_upload('test/fixtures/home_image.jpg')
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                          email: "user@example.com",
                          password: "password",
                          password_confirmation: "password",
                          profile: "I like squat.", picture: picture} }
    end
    # 送信されたメールがきっかり一つであることを確認
    assert_equal 1, ActionMailer::Base.deliveries.size
    # 直前に作られたインスタンスを取得(usersコントローラーのcreateアクション内の
    # @userのこと)
    user = assigns(:user)
    assert_not user.activated?
    # 有効化していない状態でログインする
    get edit_account_activation_path("Invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効の場合
    get edit_account_activation_path(user.activation_token, email: "Invalid")
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
  
end
