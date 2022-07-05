class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render :edit
      # @errors = @user.errors.full_messages
      # redirect_to edit_user_path
    end
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
