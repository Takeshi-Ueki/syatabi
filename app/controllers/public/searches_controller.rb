class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @word = params[:word]
    @range = params[:range]
    if @range == "ユーザー名"
      @search_result = User.where("name LIKE?", "%#{@word}%").page(params[:page])
    elsif @range == "プロフィール"
      @search_result = User.where("profile LIKE?", "%#{@word}%").page(params[:page])
    else
      @range = "投稿"
      @search_result = Post.where("body LIKE?", "%#{@word}%").page(params[:page])
    end
  end
end
