class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:destroy, :withdraw, :account_recovery]
  before_action :set_user
  before_action :ensure_correct_user, only: [:edit, :check]
  before_action :ensure_guest_user, only: [:edit]
  before_action :ensure_block_user, only: [:account_recovery]

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

  def destroy
    User.find(params[:id]).destroy
    redirect_to new_user_registration_path, alert: "ユーザー情報を完全に削除しました。 再度利用する場合は新規登録してください。"
  end

  def check
  end

  def withdraw
    status = params[:status]
    @user.update(withdraw_status: status)
    reset_session
    if @user.passive?
      redirect_to root_path, notice: '退会処理が完了しました'
    elsif @user.active?
      redirect_to new_user_session_path, notice: 'アカウントが復活しました'
    end
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

  def account_recovery
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    if @user != current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "ゲストユーザー"
      redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集はできません"
    end
  end

  def ensure_block_user
    @user = User.find(params[:id])
    redirect_to new_user_session_path, alert: "このアカウントは管理者により利用を制限されています。" if @user.block?
  end
end
