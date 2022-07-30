class Public::DiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_diary, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit]

  def new
    @post = Post.find(params[:post_id])
    @diary = Diary.new
  end

  def create
    @diary = current_user.diaries.new(diary_params)
    post = Post.find(params[:post_id])
    @diary.post_id = post.id
    @diary.save
    redirect_to post_diary_path(post, @diary)
  end

  def show
    @post = Post.find(params[:post_id])
    @user = @diary.user
  end

  def edit
    @post = Post.find(params[:post_id])
  end

  def update
    @post = @diary.post
    @diary.update(diary_params)
    redirect_to post_diary_path(@post, @diary)
  end

  def destroy
    @post = @diary.post
    @diary.destroy
    redirect_to post_path(@post)
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :body, :is_public)
  end

  def set_diary
    @diary = Diary.find(params[:id])
  end

  def ensure_correct_user
    if @diary.user != current_user
      redirect_to posts_path
    end
  end
end
