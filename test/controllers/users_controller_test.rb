require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                    email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                    email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "",
                                            password_confirmation: "",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
  
  # <カテゴリー一覧のテスト ここから>
  
  test "microposts category protein" do
    log_in_as(@user)
    get "/protein"
    assert_match "#プロテイン", response.body
    assert 'div.paginate', count: 1
  end
  
  test "microposts category wear" do
    log_in_as(@user)
    get "/wear"
    assert_match "#ウェア", response.body
    assert 'div.paginate', count: 1
  end

  test "microposts category training_items" do
    log_in_as(@user)
    get "/training_items"
    assert_match "#トレーニング用品", response.body
    assert 'div.paginate', count: 1
  end
  
  test "microposts category others" do
    log_in_as(@user)
    get "/others"
    assert_match "#その他", response.body
    assert 'div.paginate', count: 1
  end

  # <カテゴリー一覧のテスト ここまで>
end
