class Admin::UsersController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    @users = User.all
  end

  def show
    @posts = @user.posts
  end

  def edit
  end

  def update
    user.update(user_params)
    redirect_to admin_user_path(user.id)
  end

  private
    def user_params
      params.require(:user).permit(:is_active)
    end

    def set_user
      @user = User.find(params[:id])
    end
end
