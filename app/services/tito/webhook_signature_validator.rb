module Tito
  class WebhookSignatureValidator
    def initialize(request)
      @request = request
      @secret_token = ENV["TITO_WEBHOOK_SECURITY_TOKEN"]
    end

    def valid?
      return false if @secret_token.blank?

      provided_signature = @request.headers["Tito-Signature"]
      return false if provided_signature.blank?

      computed_signature = Base64.strict_encode64(
        OpenSSL::HMAC.digest("sha256", @secret_token, @request.raw_post)
      )

      ActiveSupport::SecurityUtils.secure_compare(computed_signature, provided_signature)
    rescue => e
      Rails.logger.error("[Tito::SignatureValidator] Error: #{e.message}")
      false
    end
  end
end
