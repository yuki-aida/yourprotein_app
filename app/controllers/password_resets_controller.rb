class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  # パスワード再設定の有効期限が切れていないか確認
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    # emailをキーとしてユーザーをデータベースから見つける
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      # パスワード再設定用トークンと送信時のタイムスタンプでデータベースの属性を更新する
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?      # 新しいパスワードが空文字列になっていないか
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)    #新しいパスワードが正しければ、更新する
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else      # 無効なパスワードであれば失敗させる (失敗した理由も表示する)
      render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # beforeフィルター
  
    # @userに代入
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する(データベースに値が存在する&&有効化されている&&
    # 認証済み)
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
  
end
