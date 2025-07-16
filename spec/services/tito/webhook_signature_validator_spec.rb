require "rails_helper"

RSpec.describe Tito::WebhookSignatureValidator do
  let(:secret_token) { "test-secret-token" }
  let(:payload)      { '{"event":"ticket.created","data":{"id":123}}' }
  let(:signature) do
    Base64.strict_encode64(
      OpenSSL::HMAC.digest("sha256", secret_token, payload)
    )
  end

  let(:request) do
    instance_double(ActionDispatch::Request,
      raw_post: payload,
      headers: { "Tito-Signature" => signature }
    )
  end

  subject { described_class.new(request) }

  before do
    allow(ENV).to receive(:[]).with("TITO_WEBHOOK_SECURITY_TOKEN").and_return(secret_token)
  end

  describe "#valid?" do
    context "with correct signature and secret" do
      it "returns true" do
        expect(subject.valid?).to be true
      end
    end

    context "when secret token is missing" do
      before { allow(ENV).to receive(:[]).with("TITO_WEBHOOK_SECURITY_TOKEN").and_return(nil) }

      it "returns false" do
        expect(subject.valid?).to be false
      end
    end

    context "when Tito-Signature header is missing" do
      let(:request) do
        instance_double(ActionDispatch::Request,
          raw_post: payload,
          headers: {} # no signature
        )
      end

      it "returns false" do
        expect(subject.valid?).to be false
      end
    end

    context "when signature is invalid" do
      let(:request) do
        instance_double(ActionDispatch::Request,
          raw_post: payload,
          headers: { "Tito-Signature" => "invalid-signature" }
        )
      end

      it "returns false" do
        expect(subject.valid?).to be false
      end
    end

    context "when an exception is raised" do
      before do
        allow(request).to receive(:raw_post).and_raise("Boom")
      end

      it "logs and returns false" do
        expect(Rails.logger).to receive(:error).with(/\[Tito::SignatureValidator\] Error: Boom/)
        expect(subject.valid?).to be false
      end
    end
  end
end
