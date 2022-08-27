class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    current_user.follow(@user.id)
    @user.create_notification_follow(current_user)
    render 'replace_follow'
  end

  def destroy
    current_user.unfollow(@user.id)
    render 'replace_follow'
  end

  def followings
    @followings = @user.followings.with_attached_profile_image.order(created_at: :desc)
  end

  def followers
    @followers = @user.followers.with_attached_profile_image.order(created_at: :desc)
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end
end
