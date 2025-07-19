
class Api::V1::ProfileController < Api::V1::BaseController
  def show
    render_success(
      message: "Profile retrieved successfully",
      data: ActiveModelSerializers::SerializableResource.new(
        current_user,
        include_tickets: true
      )
    )
  end
end
