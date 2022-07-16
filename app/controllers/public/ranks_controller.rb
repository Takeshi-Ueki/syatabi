class Public::RanksController < ApplicationController
  def new
    @posts = current_user.posts
    @rank = Rank.new
  end

  def create
    current_user.ranks.destroy_all
    rank_ids = params[:rank].values.map{|_hash| _hash.values }.flatten
    rank_ids.each do |rank_id|
      if rank_id.present?
        post_id, rank = rank_id.split("-")
        @rank = current_user.ranks.new
        @rank.post_id = post_id
        @rank.rank = rank
        @rank.save
      end
    end
    # current_rank = @ranks.find_by(user_id: current_user.id)
    # @rank.rank_replace(@rank) if current_rank.present?
    redirect_to user_path(current_user)
  end

  def edit
    @posts = current_user.posts
    @ranks = Rank.all
  end

  def update

  end

  def destroy
  end
end
