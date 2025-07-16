
module Tito
  class ApiError < StandardError
    attr_reader :response

    def initialize(message = nil, response: nil)
      @response = response
      super(message || response&.dig("message") || "Tito API request failed")
    end
  end
end
