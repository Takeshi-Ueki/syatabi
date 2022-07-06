class Post < ApplicationRecord
  has_many_attached :images

  belongs_to :user
  has_one:diary, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :lists, dependent: :destroy

  validates :body, presence: true, length: { maximum: 255 }

  def get_image(width, height)
    image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
