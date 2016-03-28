class ApplicationController < ActionController::Base
  before_filter :authenticate_user_from_token!
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from Pundit::NotAuthorizedError, :with => :access_denied

  private

  def access_denied
    render json: { errors: { base: ['Access denied'] } }, status: :forbidden
  end

  def authenticate_user_from_token!
    authenticate_with_http_token do |token, options|
      user_email = options[:email].presence
      user = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user, store: false
      end
    end
  end
end
