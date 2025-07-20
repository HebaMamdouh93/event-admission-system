class Api::V1::Auth::SessionsController < Devise::SessionsController
  include ExceptionHandler
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      sign_in(user)
      token = generate_jwt_for(user)

      render_success(
        message: "Logged in successfully",
        data: {
          token: token,
          user: ::UserSerializer.new(user)
        }
      )
    else
      render_error(message: "Invalid email or password", status: :unauthorized)
    end
  end

  def destroy
    sign_out(:user) 
    render_success(message: "Logged out successfully")
  end

  private

  def generate_jwt_for(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end
end
