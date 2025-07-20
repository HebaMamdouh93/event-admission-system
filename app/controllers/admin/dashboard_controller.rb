class Admin::DashboardController < Admin::BaseController
  include Pagy::Backend
  def index
    @pagy, @tickets = pagy(Ticket.order(created_at: :desc))
  end
end
