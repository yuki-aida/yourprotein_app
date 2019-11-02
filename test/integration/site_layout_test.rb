require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layout links" do
     # ルートパスにアクセス
    get root_path
    # 正しいviewが描写されているか確認
    assert_template 'static_pages/home'
    # ホームページへのリンクが3つあるか確認
    assert_select "a[href=?]", root_path, count: 3
    #Helpページへのリンクがあるか確認
    assert_select "a[href=?]", help_path
    #Aboutページへのリンクが二つあるか確認
    assert_select "a[href=?]", about_path, count: 2
    # Contactページへのリンクがあるか確認
    assert_select "a[href=?]", contact_path
    # Sign upページへのリンクがあるか確認
    assert_select "a[href=?]", signup_path, count: 2
    #Sign upページにアクセス
    get signup_path
    #タイトルが正しいか確認
    assert_select "title", full_title("Sign up")
    # Contactページにアクセス
    get contact_path
    # テスト環境でApplicationHelperを使う
    assert_select "title", full_title("Contact")
  end
end
