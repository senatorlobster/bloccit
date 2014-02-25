class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  # default_scope order('created_at DESC')  # This was my original default scope.
  default_scope order('updated_at DESC')

  validates :body, length: { minimum: 5 }, presence: true
  validates :post, presence: true
  validates :user, presence: true

  after_create :send_favorite_emails

  private

  def send_favorite_emails
    # for every favorite associated with post, send email
    self.post.favorites.each do |favorite|
      # check that the user who receives the email is different than the user creating the comment
      # also check that the user who receives the email has their permissions set to receive emails
      if favorite.user_id != self.user_id && favorite.user.email_favorites?
        FavoriteMailer.new_comment(favorite.user, self.post, self).deliver
      end
    end
  end
end
