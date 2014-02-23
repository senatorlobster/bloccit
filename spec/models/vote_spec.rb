# vote_spec.rb

require 'spec_helper'

describe Vote do

  describe "#up_vote?" do
    it "returns true for an up vote" do
      v = Vote.new(value: 1)
      v.up_vote?.should be_true
    end
    it "returns false for a down vote" do
      v = Vote.new(value: -1)
      v.up_vote?.should be_false
    end
  end

  describe "#down_vote?" do
    it "returns true for a down vote" do
      v = Vote.new(value: -1)
      v.down_vote?.should be_true
    end
    it "returns false for an up vote" do
      v = Vote.new(value: 1)
      v.down_vote?.should be_false
    end
  end

  describe "#update_post" do
    it "calls `update_rank` on post" do
      # These three lines were used before installing FactoryGirl.
      # Post.skip_callback(:create,:after,:create_redis_vote)
      # post = Post.new
      # post.save(validate: false)
      
      post = create(:post)
      post.should respond_to(:update_rank)  # This will ensure the test fails if the method name changes.
      post.should_receive(:update_rank)
      Vote.create(value: 1, post: post)
    end
  end

end