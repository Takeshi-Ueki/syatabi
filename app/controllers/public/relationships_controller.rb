class Public::RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @followings = user.followings.order(created_at: :desc)
  end

  def followers
    user = User.find(params[:user_id])
    @followers = user.followers.order(created_at: :desc)
  end
end
