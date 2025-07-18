module Tito
  class TicketVerifierService
    def initialize(email:)
      @email = email
    end

    def valid_ticket?
      tickets, = Tito::TicketsFetcherService.new(search: @email).call
      tickets.present?
    rescue Tito::ApiError => e
      Rails.logger.error("[Tito::Verifier] Error: #{e.message}")
      false
    end
  end
end
