# models/topic.rb

class Topic < ActiveRecord::Base
  has_many :posts, dependent: :destroy

  scope :visible_to, lambda { |user| user ? scoped : where(public: true) }
end
