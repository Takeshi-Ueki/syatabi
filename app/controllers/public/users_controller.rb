class Public::UsersController < ApplicationController
  before_action :set_user
  before_action :ensure_guest_user, only: [:edit]

  def show
    posts = @user.posts_with_reposts
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(5)
    favorites = @user.favorites.order(created_at: :desc).first(5).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
    ranks = @user.ranks.order(rank: :asc).pluck(:post_id)
    @rank_posts = Post.find(ranks)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: 'ユーザー情報を保存しました'
    else
      render :edit
    end
  end

  def check
  end

  def withdraw
    @user.update(is_active: false)
    reset_session
    redirect_to root_path
  end

  def favorites
    favorites = @user.favorites.order(created_at: :desc).pluck(:post_id)
    favorite_posts = Post.find(favorites)
    @favorite_posts = Kaminari.paginate_array(favorite_posts).page(params[:page]).per(10)
  end

  def lists
    lists = @user.lists.order(created_at: :desc).pluck(:post_id)
    posts = Post.find(lists)
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
  end

  private
    def user_params
      params.require(:user).permit(:name, :profile, :profile_image)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.name == "ゲストユーザー"
        redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集はできません"
      end
    end
end
