class Post < ApplicationRecord
  has_many_attached :images

  attribute :attached_at, :datetime

  belongs_to :user
  has_one :diary, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :reposts, dependent: :destroy

  has_many :tags, through: :post_tags

  validates :body, presence: true, length: { maximum: 255 }
  validate :image_precense, :image_size

  scope :tag_posts, -> (tag_id) {where(id: PostTag.where(tag_id: tag_id).pluck(:post_id))}
  scope :no_favorite_posts, -> {where.not(id: Favorite.pluck(:post_id).uniq).order(created_at: :desc)}

  def image_precense
    if !images.attached? # ファイルがアタッチされていない場合
      errors.add(:images, '画像ファイルが選択されていません')
    end
  end

  def image_size
    images.each do |image|
      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "画像は一つのファイルを5MB以内にしてください")
      end
    end
  end

  def get_image(width, height)
    image.variant(resize_to_limit: [width, height]).processed
  end

  # 投稿をいいねしているか判断
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def reposted_by?(user)
    reposts.exists?(user_id: user.id)
  end

  def listed_by?(user)
    lists.exists?(user_id: user.id)
  end
  
  def has_list(user)
    list = self.lists.find_by(user_id: user.id)
  end

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) if !self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      if !new.empty?
        new_post_tag = Tag.find_or_create_by(name: new)
        self.tags << new_post_tag
      end
    end
  end
end
