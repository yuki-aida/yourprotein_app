require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
    # full_titleヘルパーの単体テスト
    test "full_title_helper" do
        # 引数が空のfull_titleが正しいかどうか
        assert_equal full_title, "Yourprotein App"
        # 引数がHelpのfull_titleが正しいかどうか
        assert_equal full_title("Help"), "Help | Yourprotein App"
    end
end