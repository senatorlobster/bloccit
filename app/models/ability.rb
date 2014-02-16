class Ability
  include CanCan::Ability

  def initialize(user)
    # Additional details about how to define user abilities is located on the web, here:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user

    # if a member, they can manage their own posts 
    # (or create new ones)
    if user.role? :member
      can :manage, Post, :user_id => user.id
      can :manage, Comment, :user_id => user.id
      can :create, Vote
      can :manage, Favorite, user_id: user.id
      can :read, Topic
    end

    # Moderators can delete any post
    if user.role? :moderator
      can :destroy, Post
      can :destroy, Comment
    end

    # Admins can do anything
    if user.role? :admin
      can :manage, :all
    end

    # Non-signed-in users can read public topics and posts
    # can :read, :all
    can :read, Topic, public: true
    can :read, Post
  end
end
