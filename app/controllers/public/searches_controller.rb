class Public::SearchesController < ApplicationController
  def search
    @word = params[:word]
    @range = params[:range]
    if @range == "ユーザー名"
      @search_result = User.where("name LIKE?", "%#{@word}%")
    elsif @range == "プロフィール"
      @search_result = User.where("profile LIKE?", "%#{@word}%")
    else
      @range = "投稿"
      @search_result = Post.where("body LIKE?","%#{@word}%")
    end
  end
end
