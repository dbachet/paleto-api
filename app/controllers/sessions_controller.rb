class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super do |user|
      data = {
        token: user.authentication_token,
        email: user.email,
        id: user.id
      }
      render json: data.to_json, status: 201 and return
    end
  end
end
