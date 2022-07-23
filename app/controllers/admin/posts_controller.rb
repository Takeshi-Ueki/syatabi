class Admin::PostsController < ApplicationController
  before_action :set_post, except: [:index]

  def index
    @posts = Post.includes(:user, :tags).with_attached_images.order(created_at: :desc)
  end

  def show
    @user = @post.user
    gon.lat = @post.lat.to_f
    gon.long = @post.long.to_f
    @post_tags = @post.tags
    @post_comments = @post.post_comments.includes(:user)
  end

  def edit
    @user = @post.user
    @post_comments = @post.post_comments.includes(:user)
  end

  def update
    @post.update(post_params)
    redirect_to admin_post_path(@post.id)
  end

  private
    def post_params
      params.require(:post).permit(:is_active)
    end

    def set_post
      @post = Post.find(params[:id])
    end
end
