class Public::PostCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id
    @post_comment.save
    @post.create_notification_comment(current_user, @post_comment.id)
  end

  def destroy
    @post = Post.find(params[:post_id])
    post_comment = PostComment.find(params[:id])
    post_comment.destroy
  end

  private
    def post_comment_params
      params.require(:post_comment).permit(:comment)
    end
end
