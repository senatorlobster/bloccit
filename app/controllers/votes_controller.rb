# votes_controller.rb

class VotesController < ApplicationController
  before_filter :setup

  # up_vote is used in _voter.html.erb by topic_post_up_vote_path
  def up_vote
    update_vote(1)
    redirect_to :back
  end

  # down_vote is used in _voter.html.erb by topic_post_down_vote_path
  def down_vote
    update_vote(-1)
    redirect_to :back
  end

  # toggle_vote is used in _redis_voter.html.erb by topic_post_change_vote_path
  def toggle_vote
    if REDIS.sismember "user:#{current_user.id}:voted_posts", params[:post_id] # check if vote exists
      # if so, remove it
      REDIS.srem "user:#{current_user.id}:voted_posts", params[:post_id]
      REDIS.srem "post:#{params[:post_id]}:voted_users", current_user.id
      REDIS.decr "user:#{current_user.id}:total_votes"
      REDIS.decr "post:#{params[:post_id]}:total_votes"
    else
      # if not, add it
      REDIS.sadd "user:#{current_user.id}:voted_posts", params[:post_id]
      REDIS.sadd "post:#{params[:post_id]}:voted_users", current_user.id
      REDIS.incr "user:#{current_user.id}:total_votes"
      REDIS.incr "post:#{params[:post_id]}:total_votes"        
    end
    Post.find(params[:post_id]).update_redis_rank
    redirect_to :back
  end

  private

  def setup
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    authorize! :create, Vote, message: "You need to be a member to vote."

    # Look for an existing vote by this person so we don't create multiple
    @vote = @post.votes.where(user_id: current_user.id).first
  end

  def update_vote(new_value)
    if @vote # if it exists, update it
      @vote.update_attribute(:value, new_value)
    else # create it
      @vote = current_user.votes.create(value: new_value, post: @post)
    end
  end
end