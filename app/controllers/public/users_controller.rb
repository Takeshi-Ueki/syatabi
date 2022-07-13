class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts_with_reposts
    favorites = Favorite.where(user_id: @user.id).order(created_at: :desc).first(5).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
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
    end
  end

  def check
    @user = User.find(params[:id])
  end

  def withdraw
    user = User.find(params[:id])
    user.update(is_active: false)
    reset_session
    redirect_to root_path
  end

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).order(created_at: :desc).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  def lists
    @user = User.find(params[:id])
    lists = List.where(user_id: @user.id).order(created_at: :desc).pluck(:post_id)
    @posts = Post.find(lists)
  end

  private
    def user_params
      params.require(:user).permit(:name, :profile, :profile_image)
    end
end
