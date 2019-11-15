class SessionsController < ApplicationController
  def new
  end
  
  def create
    # フォームから送信されたemailをデータベースで検索
    @user = User.find_by(email: params[:session][:email].downcase)
    # フォームから送信されたUserがデータベースにあり、かつユーザーの認証に成功
    # した場合
    if @user && @user.authenticate(params[:session][:password])
    # アカウントが有効化されている場合の処理
     if @user.activated?
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    # されていない場合の処理
     else
      message  = "Account not activated. "
      message += "Check your email for the activation link."
      flash[:warning] = message
      redirect_to root_url
     end
    else
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない"
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
