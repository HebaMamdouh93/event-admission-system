class SyncTitoTicketsPageJob < ApplicationJob
  queue_as :default

  def perform(page)
    tickets, _ = Tito::TicketsFetcherService.new(page: page).call
    return if tickets.blank?

    tickets.each do |ticket_data|
      Tito::TicketSyncService.new(ticket_data).call
    end
  rescue Tito::ApiError => e
    Rails.logger.error("[Tito::ApiError] Page #{page}: #{e.message}")
    raise e
  rescue => e
    Rails.logger.error("[SyncTitoTicketsPageJob] Unexpected: #{e.message}")
    raise e
  end
end
