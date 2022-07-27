class Public::DiariesController < ApplicationController
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
    @diary = Diary.find(params[:id])
    @user = @diary.user
  end

  def edit
    @post = Post.find(params[:post_id])
    @diary = Diary.find(params[:id])
  end

  def update
    @diary = Diary.find(params[:id])
    @post = @diary.post
    @diary.update(diary_params)
    redirect_to post_diary_path(@post, @diary)
  end

  def destroy
    @diary = Diary.find(params[:id])
    @post = @diary.post
    @diary.destroy
    redirect_to post_path(@post)
  end

  private
    def diary_params
      params.require(:diary).permit(:title, :body, :is_public)
    end
end
