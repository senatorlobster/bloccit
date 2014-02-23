class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :value, inclusion: { in: [-1, 1], message: "%{value} is not a valid vote." }

  after_save :update_post        # Updates post using traditional Vote model
  after_save :update_redis_post  # Updates post using redis on/off voting

  def up_vote?
    value == 1
  end

  def down_vote?
    value == -1
  end

  private

  def update_post
    self.post.update_rank
  end

  def update_redis_post
    self.post.update_redis_rank
  end
end
