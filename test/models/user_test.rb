require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # setupメソッドは各テストが走る前に実行される
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
        password: "foobar", password_confirmation: "foobar")
  end
  
  # @userの値が正しいかどうかテスト
  test "should be valid" do
    assert @user.valid?
  end
  
  # @user.nameの値が空の場合、検知されるかどうかテスト
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  
  # @user.emailの値が空の場合、検知されるかどうかテスト
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  # @user.nameの値の長さが50字以下になっているかテスト
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  # @user.emailの値の長さが255字以下になっているかテスト
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  # emailのバリデーションが有効なアドレスを受け入れるかテスト
  test "email validation accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  # emailのバリデーションが無効なアドレスを弾くかどうかテスト
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid" 
    end
  end
  
  # 重複するメールアドレス拒否のテスト
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  # メールアドレスの小文字化に対するテスト
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    # mixed_case_emailを小文字化した値と@user.emailをデータベースの値でreloadした
    # ものが等しいことをテスト
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  # passwordが空でないことを確かめるテスト
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  # passwordの最小文字数を確かめるテスト
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do
    # ユーザーに関連づけられたマイクロポストがユーザーを削除すると同時に削除される
    # ことを確かめる
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
  
end
