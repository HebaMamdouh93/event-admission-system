module ApiResponse
  def render_success(message:, data: {}, status: :ok)
    render json: { message:, data: }, status:
  end

  def render_error(message:, errors: [], status: :unprocessable_entity)
    render json: { message:, errors: }, status:
  end
end
