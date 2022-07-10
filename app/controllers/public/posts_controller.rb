class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    tag_list = params[:post][:tag_name].split(/,| /)
    if @post.save
      @post.save_tag(tag_list)
      redirect_to posts_path
    else
      render :new
    end
  end

  def index
    user_ids = current_user.followings.pluck(:followed_id)
    user_ids.push(current_user.id)
    @posts = Post.where(user_id: user_ids).order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    gon.lat = @post.lat.to_f
    gon.long = @post.long.to_f
    @post_tags = @post.tags
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    gon.lat = @post.lat.to_f
    gon.long = @post.long.to_f
  end

  def update
    @post = Post.find(params[:id])
    image_update = params[:post][:image_ids]
    tag_list = params[:post][:tag_name].split(/,| /)
    if image_update.present?
      image_update.each do |image_id|
        image= @post.images.find(image_id)
        image.purge
      end
    end
    if @post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to user_path(current_user.id)
  end

  def favorites
    @post = Post.find(params[:id])
    favorites = Favorite.where(post_id: @post.id).order(created_at: :desc).pluck(:user_id)
    @favorite_users = User.find(favorites)
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    if params[:sort].present?
      @posts = @tag.posts.order(params[:sort])
    else
      @posts = @tag.posts.order(created_at: :desc)
    end
  end

  private
    def post_params
      params.require(:post).permit(:body, :lat, :long, images: [])
    end
end
