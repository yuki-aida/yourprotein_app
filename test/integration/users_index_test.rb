require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @non_activated_user = users(:non_activated)
  end
  
  test "index including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    # ページネーションクラスを持ったdivタグがあるか確認
    assert_select 'div.pagination', count: 2
    first_page_of_user = User.paginate(page: 1)
    first_page_of_user.each do |user|
      # ユーザー詳細ページへのリンクがあるか確認
      assert_select 'a[href=?]', user_path(user), text: user.name
      # userがadminでない場合はdeleteリンクを表示させる
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    # indexページにアクセス
    get users_path
    # <a href="">delete</a>が一つもないことを確認
    assert_select 'a', text: 'delete', count: 0
  end
  
  # 有効化されていないユーザーはindexページに表示されないことを確認
  test "should not allow the non_activated user" do
    log_in_as (@non_activated_user)
    assert_not @non_activated_user.activated?
    get users_path
    assert_select "a[href=?]", user_path(@non_activated_user), count: 0
    get user_path(@non_activated_user)
    assert_redirected_to root_url
  end
 
end
