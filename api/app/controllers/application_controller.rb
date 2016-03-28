class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from Pundit::NotAuthorizedError, :with => :access_denied

  private

  def access_denied
    render json: { errors: { base: ['Access denied'] } }, status: :forbidden
  end
end
