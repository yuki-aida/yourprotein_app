class UsersController < ApplicationController
  # edit、updateアクションが実行される前に実行されるフィルター
  before_action :logged_in_user, only:[:edit, :update, :index, :destroy,
                                  :following, :followers, :likes, :protein, :wear,
                                    :training_items, :others]
  before_action :correct_user, only:[:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    # class名: User::ActiveRecord_Relation 
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    # /users/:idから値を取得して@userに代入
    @user = User.find(params[:id])
    # class名: Micropost::ActiveRecord_AssociationRelation 
    @microposts = @user.microposts.paginate(page: params[:page])
    # ユーザーが有効化されていない場合はルートURLにリダイレクトさせる
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
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
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_following'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_followers'
  end
  
  def search
    @microposts = Micropost.all.paginate(page: params[:page]).search(params[:search])
    @user = current_user
    @title = "検索結果"
    render 'search_posts'
  end
  
  def likes
    @user = User.find(params[:id])
    @likes = Like.where(user_id: @user.id)
    # クラス名: Array(ただの配列だからモデルにあるsearchメソッドが使えない)
    # Arrayクラスに対してMicropostクラスメソッドは使えない
    @microposts = @likes.map do |like|
      like.micropost
    end
    render 'show_likes'
  end
  
  def protein
    @title = "#プロテイン"
    @category = "#プロテイン"
    # @category_url = "/protein"
    @user = current_user
    @microposts = Micropost.paginate(page: params[:page]).where(category: "protein")
    render 'category_posts'
  end
  
  def wear
    @title = "#ウェア"
    @category = "#ウェア"
    # @category_url = "/wear"
    @user = current_user
    @microposts = Micropost.paginate(page: params[:page]).where(category: "wear")
    render 'category_posts'
  end
  
  def training_items
    @title = "#トレーニング用品"
    @category = "#トレーニング用品"
    # @category_url = "/training_items"
    @user = current_user
    @microposts = Micropost.paginate(page: params[:page]).where(category: "training_items")
    render 'category_posts'
  end
  
  def others
    @title = "#その他"
    @category = "#その他"
    # @category_url = "/others"
    @user = current_user
    @microposts = Micropost.paginate(page: params[:page]).where(category: "others")
    render 'category_posts'
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :profile, :picture)
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
