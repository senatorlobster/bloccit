class PostsController < ApplicationController

  # The 'index' action can be removed from this file because it's no longer needed
  # now that all post URLs are scoped to a topic.
  #
  # def index
  #   @posts = Post.all
  # end

  def show
    @topic = Topic.find(params[:topic_id])
    authorize! :read, @topic, message: "You need to be signed-in to do that."
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
    # @comments = @post.comments.page(params[:page]).per(10)
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
    authorize! :create, Post, message: "You need to be a member to create a new post."
  end

  # Adding a create method to the posts_controller.rb

  def edit
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])
    authorize! :edit, @post, message: "You can only edit your own posts."
  end

  def create
#   @post = Post.new(params[:post])
    @topic = Topic.find(params[:topic_id])
    @post = current_user.posts.build(params[:post])
    @post.topic = @topic

    authorize! :create, @post, message: "You need to be signed up to do that."
    if @post.save
      redirect_to [@topic, @post], notice: "Post was saved successfully."
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def update
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])

    authorize! :update, @post, message: "You can only update your own posts."
    if @post.update_attributes(params[:post])
      redirect_to [@topic, @post], notice: "Post was updated successfully."
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])

    title = @post.title
    authorize! :destroy, @post, message: "You can only delete posts that you own."
    if @post.destroy
      flash[:notice] = "\"#{title}\" was deleted successfully."
      redirect_to @topic
    else
      flash[:error] = "There was an error deleting the post."
      render :show
    end
  end
end
