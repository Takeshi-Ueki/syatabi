class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, except: [:index]

  def index
    @users = User.page(params[:page])
  end

  def show
    @posts = @user.posts.page(params[:page])
  end

  def edit
  end

  def update
    @user.update(withdraw_status: "block")
    redirect_to admin_user_path(@user.id)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
