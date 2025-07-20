class Api::V1::Auth::RegistrationsController < Devise::RegistrationsController
  include ExceptionHandler

  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    if !ticket_valid?(sign_up_params[:email])
      return render_error(
        message: "You must have a valid Tito ticket to register."
      )
    end

    super
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render_success(
        message: "Signed up successfully. Please confirm your email."
      )
    else
      render_error(
        message: "Sign up failed.",
        errors: resource.errors.full_messages
      )
    end
  end

  def sign_up_params
    params.permit(:email, :password, :password_confirmation)
  end

  def ticket_valid?(email)
    Tito::TicketVerifierService.new(email:).valid_ticket?
  end
end
