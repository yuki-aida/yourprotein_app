class UsersController < ApplicationController
  
  def show
    # /users/:idから値を取得して@userに代入
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    # @user = User.new(name: "", email: "", password: "", password_confirmation:
    #                     "")と同義
    if @user.save
      # 保存に成功した時の処理
      flash[:success] = "Welcome to the YourProtein App!"
      # redirect_to user_url(@user)と同義
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  
end
