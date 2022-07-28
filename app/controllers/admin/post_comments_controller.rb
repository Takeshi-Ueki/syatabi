class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def update
    post = Post.find(params[:post_id])
    status = params[:status]
    PostComment.find(params[:id]).update(is_active: status)
    redirect_to admin_post_path(post.id)
  end
end
