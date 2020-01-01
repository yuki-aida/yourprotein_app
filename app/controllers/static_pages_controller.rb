class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = User.find(current_user.id)
      @feed_items = current_user.feed.paginate(page: params[:page])
      # like拡張機能
      @likes = Like.where(micropost_id: params[:micropost_id])
    end
  end

  def help
  end

  def about
  end
  
  def contact
  end
end
