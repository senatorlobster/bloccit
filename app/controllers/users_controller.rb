class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.visible_to(current_user)
  end

  def index
    @users = User.top_rated.page(params[:page]).per(10)
  end

end