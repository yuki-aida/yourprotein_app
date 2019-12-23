class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
  def new
    @micropost = current_user.microposts.build
  end
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'microposts/new'
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # 一つ前のURLを返す(deleteリクエストが発行されたページ)
    redirect_to request.referrer || root_url
  end
  
  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture, :title, :category)
    end
    
    def correct_user
      # @microposts.each do |micropost|の値を取得
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
  
end
