module ExceptionHandler
  extend ActiveSupport::Concern
  
  include ApiResponse

  included do
    rescue_from ActiveRecord::RecordNotFound,        with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid,         with: :handle_unprocessable_entity
    rescue_from StandardError,                       with: :handle_internal_error
  end

  private

  def handle_not_found(error)
    render_error(
      message: "Record not found",
      errors: [error.message],
      status: :not_found
    )
  end

  def handle_unprocessable_entity(error)
    render_error(
      message: "Unprocessable entity",
      errors: [error.record.errors.full_messages],
      status: :unprocessable_entity
    )
  end

  def handle_internal_error(error)
    logger.error error.full_message
    render_error(
      message: "Internal server error",
      errors: [error.message],
      status: :internal_server_error
    )
  end
  
end
