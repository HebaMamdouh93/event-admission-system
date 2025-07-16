module Tito
  class TicketSyncService
    def initialize(ticket_data)
      @data = ticket_data
    end

    def call
      ticket = Ticket.find_or_initialize_by(tito_ticket_id: @data["id"])

      ticket.assign_attributes(mapped_attributes)

      if ticket.save
        Rails.logger.info("Synced ticket ##{ticket.tito_ticket_id}")
      else
        Rails.logger.error("Failed to sync ticket ##{ticket.tito_ticket_id}: #{ticket.errors.full_messages.join(', ')}")
      end
    end

    private

    def mapped_attributes
      {
        tito_ticket_slug: @data["slug"],
        tito_ticket_id: @data["id"],
        email: @data["email"],
        name: @data["name"],
        phone_number: @data["phone_number"],
        state: @data["state"] || @data["state_name"],
        tito_created_at: @data["created_at"],
        tito_info: @data
      }
    end
  end
end
