class TopicsController < ApplicationController

  # I've commented out the lines necessary for user authentication.
  # At this point, any user can create any topic.

  def index
    # @topics = Topic.all
    # @topics = Topic.page(params[:page]).per(10)
    @topics = Topic.visible_to(current_user).page(params[:page]).per(10)
  end

  def new
    @topic = Topic.new
    authorize! :create, @topic, message: "You need to be an admin to create a new topic."
  end

  def show
    @topic = Topic.find(params[:id])
    authorize! :read, @topic, message: "You need to be signed-in to do that."
    # @posts = @topic.posts
    # @posts = @topic.posts.page(params[:page]).per(10) # same as below, but without eager loading
    # @posts = @topic.posts.includes(:user).page(params[:page]).per(10) # uses eager loading for users
    @posts = @topic.posts.includes(:user).includes(:comments).page(params[:page]).per(10)  # uses eager loading for users and comments
  end

  def edit
    @topic = Topic.find(params[:id])
    # Bloc uses "authorize! :update" below, but I've left it
    # as :edit to follow the convention I established for Posts.
    authorize! :edit, @topic, message: "You need to be an admin to edit topics."
  end

  def create
    @topic = Topic.new(params[:topic])
#    @topic = current_user.topics.build(params[:post])
    authorize! :create, @topic, message: "You need to be an admin to create a topic."
    if @topic.save
      flash[:notice] = "Topic was saved."
      redirect_to @topic
      # the below is a way of saying the previous two lines in a single line:
      # redirect_to @topic, notice: "Topic was saved successfully."
    else
      flash[:error] = "There was an error saving the topic. Please try again."
      render :new
    end
  end

  def update
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You can only update topics you own."
    if @topic.update_attributes(params[:topic])
      flash[:notice] = "Topic was updated."
      redirect_to @topic
      # the below is another way of saying the two lines above on a single line:
      # redirect_to @topic, notice: "Topic was saved successfully."
    else
      flash[:error] = "There was an error saving the topic. Please try again."
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    name = @topic.name
    authorize! :destroy, @topic, message: "Only administrators can delete topics."
    if @topic.destroy
      flash[:notice] = "\"#{name}\" was deleted successfully."
      redirect_to topics_path
    else
      flash[:error] = "There was an error deleting the topic."
      render :show
    end
  end
end
