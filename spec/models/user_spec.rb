# spec/models/user_spec.rb

require 'spec_helper'

describe User do

  # describe "#set_member" do
  #   it "assigns 'member' to its role" do
  #     # These three lines were used before installing FactoryGirl.
  #     # Post.skip_callback(:create,:after,:create_redis_vote)
  #     # post = Post.new
  #     # post.save(validate: false)
      
  #     user = create(:user)
  #     user.should respond_to(:update_rank)  # This will ensure the test fails if the method name changes.
  #     post.should_receive(:update_rank)
  #     Vote.create(value: 1, post: post)
  #   end
  # end


  describe "#role?" do

    it "should return true if member is compared to member" do
      user = create(:user)
      user.update_attribute(:role, 'member')
      user.role?("member").should be_true
    end

    it "should return false if member is compared to moderator" do
      user = create(:user)
      user.update_attribute(:role, 'member')
      user.role?("moderator").should be_false
    end

    it "should return false if member is compared to admin" do
      user = create(:user)
      user.update_attribute(:role, 'member')
      user.role?("admin").should be_false
    end

    it "should return true if moderator is compared to member" do
      user = create(:user)
      user.update_attribute(:role, 'moderator')
      user.role?("member").should be_true
    end

    it "should return true if moderator is compared to moderator" do
      user = create(:user)
      user.update_attribute(:role, 'moderator')
      user.role?("moderator").should be_true
    end

    it "should return false if moderator is compared to admin" do
      user = create(:user)
      user.update_attribute(:role, 'moderator')
      user.role?("admin").should be_false
    end

    it "should return true if admin is compared to member" do
      user = create(:user)
      user.update_attribute(:role, 'admin')
      user.role?("member").should be_true
    end

    it "should return true if admin is compared to moderator" do
      user = create(:user)
      user.update_attribute(:role, 'admin')
      user.role?("moderator").should be_true
    end

    it "should return true if admin is compared to admin" do
      user = create(:user)
      user.update_attribute(:role, 'admin')
      user.role?("admin").should be_true
    end
    
  end

  describe ".top_rated" do
    before :each do
      post = nil
      topic = create(:topic)
      
      @u0 = create(:user) do |user|
        post = user.posts.build(attributes_for(:post))
        post.topic = topic
        post.save
        c = user.comments.build(attributes_for(:comment))
        c.post = post
        c.save
      end

      @u1 = create(:user) do |user|
        c = user.comments.build(attributes_for(:comment))
        c.post = post
        c.save
        post = user.posts.build(attributes_for(:post))
        post.topic = topic
        post.save
        c = user.comments.build(attributes_for(:comment))
        c.post = post
        c.save
      end
    end

    it "should return users based on comments + posts" do
      User.top_rated.should eq([@u1, @u0])
    end

    it "should have `posts_count` on user" do
      users = User.top_rated
      users.first.posts_count.should eq(1)
    end

    it "should have `comments_count` on user" do
      users = User.top_rated
      users.first.comments_count.should eq(2)
    end

    it "should have 'rank' on user" do
      users = User.top_rated
      users.first.rank.should eq(users.first.posts_count + users.first.comments_count)
    end
  end

end
