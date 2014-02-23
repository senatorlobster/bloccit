# models/post.rb

class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :user
  belongs_to :topic

  # Assume that if a user submits a post, they'll want to vote it up
  # after_create :create_vote             # Use create_vote for traditional up/down voting.
  after_create :create_redis_vote         # Use create_redis_vote for Redis on/off voting.
  after_destroy :cleanup_destroy_action   # Remove evidence of the vote after a post is destroyed.

  mount_uploader :post_image, PostImageUploader

  default_scope order('rank DESC')
  scope :visible_to, lambda { |user| user ? scoped : joins(:topic).where('topics.public' => true) }

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  def up_votes
    self.votes.where(value: 1).count
  end

  def down_votes
    self.votes.where(value: -1).count
  end

  # Use points method to get points to display on _voter.html.erb.
  def points
    self.votes.sum(:value).to_i
  end

  # Return the current number of votes on this post.
  def redis_post_points
    x = REDIS.get "post:#{self.id}:total_votes"
    x.to_i
  end

  def update_rank
    age = (self.created_at - Time.new(1970,1,1)) / 86400
    new_rank = points + age

    self.update_attribute(:rank, new_rank)
  end

  def update_redis_rank
    age = (self.created_at - Time.new(1970,1,1)) / 86400
    new_rank = redis_post_points + age

    self.update_attribute(:rank, new_rank)
  end

  # Return all users that have redis_voted this post.
  def redis_voted_users
    voted_user_ids = REDIS.smembers "post:#{self.id}:voted_users"
    User.where(id: voted_user_ids)
  end

  private

  # Whoever created a post should automatically be set to "voting" it up.

  # Use create_vote for traditional up/down vote model.
  def create_vote
    self.user.votes.create(value: 1, post: self)
  end

  # Use create_redis_vote for Redis-style on/off voting.
  def create_redis_vote
      REDIS.sadd "user:#{self.user.id}:voted_posts", self.id
      REDIS.sadd "post:#{self.id}:voted_users", self.user.id
      REDIS.incr "user:#{self.user.id}:total_votes"
      REDIS.incr "post:#{self.id}:total_votes"
      self.update_redis_rank
  end

  def cleanup_destroy_action
    voted_user_ids = REDIS.smembers "post:#{self.id}:voted_users"
    voted_user_ids.each do |user_id|
      REDIS.srem "user:#{user_id}:voted_posts", self.id
      REDIS.decr "user:#{user_id}:total_votes"
    end
    REDIS.del "post:#{self.id}:voted_users"
    REDIS.del "post:#{self.id}:total_votes"
  end
end
