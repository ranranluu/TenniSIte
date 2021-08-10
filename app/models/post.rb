class Post < ApplicationRecord
  
  belongs_to :user
  
  has_many :likes, dependent: :destroy
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
  
  has_many :liked_users, through: :likes, source: :user
  
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  
end
