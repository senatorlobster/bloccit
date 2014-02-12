class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def handle_unverified_request
    redirect_to new_user_session_url, :alert => "You need to be signed in to do that."
  end

  # Get Devise working with Strong Parameters so that 
  # extra fields- beyond email and password- work in 
  # user registration forms.

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :name << :avatar
  end

end
