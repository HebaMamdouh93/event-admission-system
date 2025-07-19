class Api::V1::TicketsController < Api::V1::BaseController
  def show
    ticket = current_user.tickets.find(params[:id])
    render_success(
        message: "Ticket retrieved successfully",
        data: {
          ticket: ::TicketSerializer.new(ticket)
        }
      )
  rescue ActiveRecord::RecordNotFound
    render_error(message: "Ticket not found", status: :not_found)
  end
end
