class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.save
    redirect_to posts_path
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    image_update = params[:post][:image_ids]
    if image_update.present?
      image_update.each do |image_id|
        image= @post.images.find(image_id)
        image.purge
      end
    end
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
  end

  def search_tag
  end

  private
    def post_params
      params.require(:post).permit(:body, images: [])
    end
end
