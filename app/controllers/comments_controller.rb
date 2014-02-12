class CommentsController < ApplicationController

  # The 'create' method creates the Comment object after the form is submitted.
  # No 'new' method is required because a new, blank form for each new comment
  # will be shown in the Post view rather than on its own page.

  def create
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(params[:comment])
    @comment.post = @post
    @comments = @post.comments

    authorize! :create, @comment, message: "You need to be signed up to do that."
    if @comment.save
      redirect_to [@topic, @post], notice: "Comment was saved successfully."
    else
      flash[:error] = "There was an error saving the comment. Please try again."
      render "posts/show"
    end
  end
end
