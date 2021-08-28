class HomesController < ApplicationController
  def top
    @likeposts = Post.includes(:liked_users).sort { |a, b| b.liked_users.size <=> a.liked_users.size }.first(5)
    @newposts = Post.all.order(created_at: :desc).limit(5)
  end

  def about
  end
end
