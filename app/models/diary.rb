class Diary < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :body, presence: true, length: { maximum: 30000 }
end
