class Rank < ApplicationRecord
  enum rank: { first_place: 0, second_place: 1, third_place: 2 }

  belongs_to :user
  belongs_to :post

  validate :rank_overlap

  # def rank_overlap
  #   user = current_user
  #   current_ranks = Rank.where(user_id: user.id)
  #   if current_ranks.present?
  #     current_ranks.each do |current_rank|
  #       if current_rank.rank == rank
  #         errors.add(:rank, "順位が重複しています。 1位~3位は1件ずつ選択してください。")
  #       end
  #     end
  #   end
  # end
end
