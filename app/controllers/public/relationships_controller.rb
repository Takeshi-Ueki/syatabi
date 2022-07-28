class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user.id)
    @user.create_notification_follow(current_user)
    render 'replace_follow'
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user.id)
    render 'replace_follow'
  end

  def followings
    user = User.find(params[:user_id])
    @followings = user.followings.with_attached_profile_image.order(created_at: :desc)
  end

  def followers
    user = User.find(params[:user_id])
    @followers = user.followers.with_attached_profile_image.order(created_at: :desc)
  end
end
