require "httparty"

module Tito
  class ApiClient
    include HTTParty
    base_uri ENV.fetch("TITO_BASE_URL")

    def initialize
      @headers = {
        "Authorization" => "Token token=#{ENV.fetch('TITO_API_TOKEN')}",
        "Accept" => "application/json"
      }
      @account = ENV.fetch("TITO_ACCOUNT_NAME")
      @event = ENV.fetch("TITO_EVENT_NAME")
    end

    def list_tickets(page: 1, search: nil)
      query = { page: page }
      query[:search] = { q: search } if search.present?

      get("/#{@account}/#{@event}/tickets", query: query)
    end

    def search_tickets_by_email(email)
      get("/#{@account}/#{@event}/tickets", query: { search: { q: email } })
    end

    def ticket_details(ticket_slug)
      get("/#{@account}/#{@event}/tickets/#{ticket_slug}")
    end

    private

    def get(path, query: {})
      response = self.class.get(path, headers: @headers, query: query)
      handle_response(response)
    rescue SocketError, Net::OpenTimeout, Net::ReadTimeout => e
      raise Tito::ApiError.new("Network error: #{e.message}")
    end

    def handle_response(response)
      if response.success?
        response
      else
        Rails.logger.error("[Tito API ERROR] Status: #{response.code}, Body: #{response.body}")
        raise Tito::ApiError.new("Tito API error (#{response.code})", response: response.parsed_response)
      end
    end
  end
end
