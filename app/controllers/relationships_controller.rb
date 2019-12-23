class RelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user } #ブラウザ側でJavaScriptが無効になっていた場合(Ajaxリクエストに非対応)
      format.js #ブラウザ側でJavaScriptが有効な場合(Ajaxリクエストに対応)
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
end
