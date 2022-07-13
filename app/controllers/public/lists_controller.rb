class Public::ListsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @list = current_user.lists.new
    @list.post_id = @post.id
    @list.save
    redirect_to user_lists_path(current_user)
  end

  def update
    @list = List.find(params[:id])
    @list.update(list_params)
    redirect_to user_lists_path(current_user)
  end

  def destroy
    post = Post.find(params[:post_id])
    list = post.has_list(current_user)
    list.destroy
    redirect_to user_lists_path(current_user)
  end

  private
    def list_params
      params.require(:list).permit(:memo)
    end
end
