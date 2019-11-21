class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # 全コントローラーでSessionsHelperが使えるようにする
  include SessionsHelper
  
  private
    # ログイン済みのユーザーか確認
      def logged_in_user
        # current_userがnilの場合
        unless logged_in?
          store_location
          flash[:danger] = "Please log in"
          redirect_to login_url
        end
      end
end
