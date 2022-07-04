class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def check
  end

  def withdraw
  end

  private
    def user_params
      params.require(:user).permit(:name, :profile, :profile_image)
    end
end
