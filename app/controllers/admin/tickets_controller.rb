class Admin::TicketsController < Admin::BaseController
  before_action :set_ticket, only: [:show, :destroy]

  def show
  end

  def destroy
    @ticket.destroy
    redirect_to admin_dashboard_path, notice: "Ticket was successfully soft deleted."
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end
end
