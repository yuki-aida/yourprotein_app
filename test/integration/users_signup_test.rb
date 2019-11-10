require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
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
  
  test "valid signup information" do
    get signup_path
    # assert_differenceブロック内の処理を実行する直前のUser.countの値と実行した後の
    # 値を比較
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                          email: "user@example.com",
                          password: "password",
                          password_confirmation: "password" } }
    end
    # POSTリクエストを送信した結果を見て、指定されたリダイレクト先に移動するメソッド
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
  
end
