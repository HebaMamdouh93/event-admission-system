module Tito
  class TicketsFetcherService
    def initialize(page: 1, search: {})
      @page = page
    end

    def call
      client = ApiClient.new
      response = client.list_tickets(page: @page)
      response.parsed_response["tickets"]
    end
  end
end
