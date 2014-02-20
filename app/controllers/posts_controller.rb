class PostsController < ApplicationController
  def index
    @posts = Post.visible_to(current_user).where("posts.created_at > ?",7.days.ago).page(params[:page]).per(10)
  end
end
