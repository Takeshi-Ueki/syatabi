class Public::RepostsController < ApplicationController
  before_action :set_post

  def create
    repost = current_user.reposts.new
    repost.post_id = @post.id
    repost.save
    redirect_to request.referer
  end

  def destroy
    repost = current_user.reposts.find_by(post_id: @post.id)
    repost.destroy
    redirect_to request.referer
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end
end
