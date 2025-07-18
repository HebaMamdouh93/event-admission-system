module Tito
  class TicketsFetcherService
    def initialize(page: 1, search: {})
      @page = page
      @search = search
    end

    def call
      client = ApiClient.new
      response = client.list_tickets(page: @page, search: @search)
      [ response.parsed_response["tickets"], response.parsed_response["meta"] ]
    end
  end
end
