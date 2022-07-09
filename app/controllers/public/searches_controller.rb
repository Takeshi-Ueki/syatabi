class Public::SearchesController < ApplicationController
  def search
    @word = params[:word]
    @range = params[:range]
    if @range == "User"
      @users = User.where("name LIKE?", "%#{@word}%")
    elsif @range == "profile"
      @users = User.where("profile LIKE?", "%#{@word}%")
    else
      @posts = Post.where("body LIKE?","%#{@word}%")
    end
  end
end
