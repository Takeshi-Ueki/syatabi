class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum is_active: { active: 0, passive: 1, block: 2 }

  has_many :posts, dependent: :destroy
  has_many :ranks, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :diaries, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :repost_posts, through: :reposts, source: :post
  has_many :list_posts, through: :lists, source: :post

  # 通知を送ったユーザー、通知を送られたユーザー
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  # フォローしたユーザー、フォローされたユーザー
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

  has_one_attached :profile_image

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :profile, length: { maximum: 255 }

  def get_profile_image(width, height)
    if !profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no-image-icon.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # フォロー機能
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  # 自分の投稿とリポストを取得する user/show画面で使用する
  def posts_with_reposts
    my_posts = []
    posts.each do |post|
      post.attached_at = post.created_at
      my_posts << post
    end
    my_reposts = []
    reposts_hash = Hash[*self.reposts.pluck(:post_id, :created_at).flatten]
    repost_posts.each do |post|
      post.attached_at = reposts_hash[post.id]
      my_reposts << post
    end
    (my_posts + my_reposts).sort do |a, b|
      b.attached_at <=> a.attached_at
    end
  end

  # 自分のフォローしている人の投稿とリポストと自分の投稿とリポストを取得する
  def my_posts_with_follower_posts
    my_posts = self.posts_with_reposts

    following_posts = []
    following_reposts = []
    followings.each do |following|
      following.posts.each do |post|
        post.attached_at = post.created_at
        following_posts << post
      end
      following_reposts_hash = Hash[*following.reposts.pluck(:post_id, :created_at).flatten]
      following.repost_posts.each do |post|
        post.attached_at = following_reposts_hash[post.id]
        following_posts << post
      end
    end

    (my_posts + following_posts + following_reposts).sort do |a, b|
      b.attached_at <=> a.attached_at
    end
  end

  # フォロー通知
  def create_notification_follow(current_user)
    followed = Notification.where([ "visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, "follow" ])
    if followed.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: "follow"
      )

      notification.save
    end
  end

  # ゲストログイン
  def self.guest
    find_or_create_by!(name: "ゲストユーザー", email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end
end
