class Post < ApplicationRecord
  belongs_to :user
  belongs_to :diary, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :lists, dependent: :destroy

  has_many_attached :images
end
