class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # 全コントローラーでSessionsHelperが使えるようにする
  include SessionsHelper
end
