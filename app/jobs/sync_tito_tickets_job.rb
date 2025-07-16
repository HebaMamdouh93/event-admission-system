class SyncTitoTicketsJob < ApplicationJob
  queue_as :default

  def perform
    tickets, meta = Tito::TicketsFetcherService.new(page: 1).call

    return if tickets.blank?
    total_pages = meta["total_pages"] || 1

    # Always schedule the first page
    SyncTitoTicketsPageJob.perform_later(1)

    # Schedule remaining pages
    (2..total_pages).each do |page|
      SyncTitoTicketsPageJob.perform_later(page)
    end
  rescue Tito::ApiError => e
    Rails.logger.error("[SyncTitoTicketsJob] Tito API error: #{e.message}")
    raise e
  rescue => e
    Rails.logger.error("[SyncTitoTicketsJob] Unexpected error: #{e.message}")
    raise e
  end
end
