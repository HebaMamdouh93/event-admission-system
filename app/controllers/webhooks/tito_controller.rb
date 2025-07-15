class Webhooks::TitoController < ActionController::API
  before_action :verify_signature!

  def sync_tickets
    ticket_data = params
    Tito::TicketSyncService.new(ticket_data).call
    head :ok
  end

  private

  def verify_signature!
    validator = Tito::WebhookSignatureValidator.new(request)
    unless validator.valid?
      Rails.logger.warn("[Tito::Webhook] Invalid signature")
      head :unauthorized and return
    end
  end
end
