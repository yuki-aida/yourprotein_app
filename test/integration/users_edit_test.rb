require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "", email: "",
                          password: "", password_confirmation: "" } }
    assert_template 'users/edit'
    assert_select 'div.alert', "The form contains 3 errors."
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    # session[:forwarding_url]が正しいか確認
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "foo bar"
    email = "foobar@gmail.com"
    patch user_path(@user), params: { user: { name: name, email: email,
                          password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    # データベースの値で@userを更新
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    # ログアウトする
    delete logout_path
    # session[:forwarding_url]の値が削除されているか確認（プロフィールページに
    # リダイレクトするか確認）
    log_in_as(@user)
    assert_redirected_to @user
  end
  
end
