class CommentsController < ApplicationController
  respond_to :html, :js

  # The 'create' method creates the Comment object after the form is submitted.
  # No 'new' method is required because a new, blank form for each new comment
  # will be shown in the Post view rather than on its own page.

  def create
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(params[:comment])
    @comment.post = @post
    @comments = @post.comments
    @new_comment = Comment.new

    authorize! :create, @comment, message: "You need to be signed up to do that."
    if @comment.save
      flash[:notice] = "Comment was saved successfully."
      # redirect_to [@topic, @post], notice: "Comment was saved successfully."
    else
      flash[:error] = "There was an error saving the comment. Please try again."
      # render "posts/show"
    end

    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post] }
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    @comment = @post.comments.find(params[:id])

    authorize! :destroy, @comment, message: "You can only delete comments that you own."
    if @comment.destroy
      flash[:notice] = "Comment was deleted successfully."
      # redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error deleting the comment."
      # redirect_to [@topic, @post]
    end

    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post] }
    end
  end
end
