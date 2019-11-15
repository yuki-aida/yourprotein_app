require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    # 送信したメールのsubjectが一致するか確認
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    # メール本文にユーザーの名前があるか確認
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    # メール本文にユーザーのemailをエスケープした文字列があるか確認
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  # test "password_reset" do
  #   mail = UserMailer.password_reset
  #   assert_equal "Password reset", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

end
