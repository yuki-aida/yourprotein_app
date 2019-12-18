require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "layout links" do
     # ルートパスにアクセス
    get root_path
    # 正しいviewが描写されているか確認
    assert_template 'static_pages/home'
    # ホームページへのリンクが3つあるか確認
    assert_select "a[href=?]", root_path, count: 2
    #Helpページへのリンクがあるか確認
    assert_select "a[href=?]", help_path
    #Aboutページへのリンクが二つあるか確認
    assert_select "a[href=?]", about_path, count: 2
    # Contactページへのリンクがあるか確認
    assert_select "a[href=?]", contact_path
    # Sign upページへのリンクがあるか確認
    assert_select "a[href=?]", signup_path, count: 2
    # Log inページへのリンクがあるか確認
    assert_select "a[href=?]", login_path, count: 2
    #Sign upページにアクセス
    get signup_path
    #タイトルが正しいか確認
    assert_select "title", full_title("Sign up")
    # Contactページにアクセス
    get contact_path
    # テスト環境でApplicationHelperを使う
    assert_select "title", full_title("Contact")
  end
  
  test "layout links when logged in" do
    # テストユーザーとしてログイン
    log_in_as(@user)
    get root_path
    # レイアウトに正しいリンクがあるか確認
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_match "I like dead lift.", response.body
  end
end
