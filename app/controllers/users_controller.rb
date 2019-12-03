class UsersController < ApplicationController
  # edit、updateアクションが実行される前に実行されるフィルター
  before_action :logged_in_user, only:[:edit, :update, :index, :destroy,
                                  :following, :followers]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page]).search(params[:search])
  end
  
  def show
    # /users/:idから値を取得して@userに代入
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page]).search(params[:search])
    # like拡張機能
    @likes = Like.where(micropost_id: params[:micropost_id])
    # ユーザーが有効化されていない場合はルートURLにリダイレクトさせる
    redirect_to root_url and return unless @user.activated? 
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
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    # /users/:id/editから値を取得して@userに代入
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功した場合の処理
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page]).search(params[:search])
    render 'show_following'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page]).search(params[:search])
    render 'show_followers'
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :profile)
    end
    
    # beforeアクション
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
