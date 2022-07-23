class Post < ApplicationRecord
  has_many_attached :images

  attribute :attached_at, :datetime

  belongs_to :user
  has_one :diary, dependent: :destroy
  has_one :rank, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :tags, through: :post_tags

  validates :body, presence: true, length: { maximum: 255 }
  validate :image_precense, :image_size, :image_length

  scope :tag_posts, -> (tag_id) {where(id: PostTag.where(tag_id: tag_id).pluck(:post_id))}
  scope :no_favorite_posts, -> {where.not(id: Favorite.pluck(:post_id).uniq).order(created_at: :desc)}

  def image_precense
    if !images.attached?
      errors.add(:images, 'ファイルが選択されていません')
    end
  end

  def image_size
    images.each do |image|
      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "は一つのファイルを5MB以内にしてください")
      end
    end
  end

  def image_length
    if images.length > 3
      errors.add(:images, "は3枚以内にしてください")
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

  # いいね通知
  def create_notification_favorite(current_user)
    favorited = Notification.where([ "visitor_id = ? and visited_id = ? and post_id = ? and action = ?", current_user.id, user_id, id, "favorite" ])

    if favorited.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: "favorite"
      )

      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save
    end
  end

  # リポスト通知
  def create_notification_repost(current_user)
    reposted = Notification.where([ "visitor_id = ? and visited_id = ? and post_id = ? and action = ?", current_user.id, user_id, id, "repost" ])

    if reposted.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: "repost"
      )

      notification.save
    end
  end

  # コメント通知
  def create_notification_comment(current_user, post_comment_id)
    # 自分以外のコメントしているユーザーを取得
    post_comment_user_ids = PostComment.where(post_id: id).where.not(user_id: [current_user.id, user_id]).distinct
    post_comment_user_ids.each do |post_comment_user_id|
      save_notification_comment(current_user, post_comment_id, post_comment_user_id['user_id'])
    end
    # 自分の記事へのコメントは通知を作らない
    save_notification_comment(current_user, post_comment_id, user_id) if user_id != current_user.id
  end

  def save_notification_comment(current_user, post_comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: "comment"
      )

    notification.save
  end
end
