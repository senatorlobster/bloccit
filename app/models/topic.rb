# models/topic.rb

class Topic < ActiveRecord::Base
  has_many :posts
end
