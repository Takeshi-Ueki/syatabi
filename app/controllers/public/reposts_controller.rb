class Public::RepostsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    repost = current_user.reposts.new(post_id: @post.id)
    repost.save
    render 'replace_btn'
  end

  def destroy
    @post = Post.find(params[:post_id])
    repost = current_user.reposts.find_by(post_id: @post.id)
    repost.destroy
    render 'replace_btn'
  end
end
