class Rank < ApplicationRecord
  enum rank: { first_place: 0, second_place: 1, third_place: 2 }

  belongs_to :user
  belongs_to :post

end
