class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy, :favorites
  ]
  
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    tag_list = params[:post][:tag_name].split(/,| |　/)
    if @post.save
      @post.save_tag(tag_list)
      redirect_to posts_path, notice: '新規投稿が完了しました'
    else
      render :new
    end
  end

  def index
    if current_user.followings.empty?
      @posts = Post.page(params[:page]).per(10).order(created_at: :desc)
    else
      posts = current_user.my_posts_with_follower_posts
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
    end
  end

  def show
    @user = @post.user
    gon.lat = @post.lat.to_f
    gon.long = @post.long.to_f
    @post_tags = @post.tags
    @post_comment = PostComment.new
    @list = List.new
    @diary = @post.diary if @post.diary.present?
  end

  def edit
    @tag_list = @post.tags.pluck(:name).join(',')
    gon.lat = @post.lat.to_f
    gon.long = @post.long.to_f
  end

  def update
    image_update = params[:post][:image_ids]
    tag_list = params[:post][:tag_name].split(/,| |　/)
    if image_update.present?
      image_update.each do |image_id|
        image= @post.images.find(image_id)
        image.purge
      end
    end
    if @post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id), notice: '投稿の編集を保存しました'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to user_path(current_user.id), notice: '投稿の削除が完了しました'
  end

  def favorites
    favorites = @post.favorites.order(created_at: :desc).pluck(:user_id)
    @favorite_users = User.find(favorites)
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    if params[:sort].present?
      posts = Post.tag_posts(@tag.id).joins(:favorites).group(:post_id).order('count(post_id) desc')+(Post.no_favorite_posts)
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
    else
      @posts = @tag.posts.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  private
    def post_params
      params.require(:post).permit(:body, :lat, :long, images: [])
    end

    def set_post
      @post = Post.find(params[:id])
    end
end
