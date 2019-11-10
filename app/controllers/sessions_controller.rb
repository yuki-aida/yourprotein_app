class SessionsController < ApplicationController
  def new
  end
  
  def create
    # フォームから送信されたemailをデータベースで検索
    user = User.find_by(email: params[:session][:email].downcase)
    # フォームから送信されたUserがデータベースにあり、かつユーザーの認証に成功
    # した場合
    if user && user.authenticate(params[:session][:password])
      log_in user
      # redirect_to user_url(user)と同義
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない"
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
end
