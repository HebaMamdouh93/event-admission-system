require "rails_helper"

RSpec.describe Tito::TicketVerifierService, type: :service do
  let(:email) { "hebamamdouh2016@gmail.com" }
  subject { described_class.new(email:) }

  describe "#valid_ticket?" do
    context "when Tito API returns tickets" do
      it "returns true", :vcr do
        expect(subject.valid_ticket?).to be true
      end
    end

    context "when Tito API returns no tickets" do
      it "returns false", :vcr do
        no_ticket_email = "noticket@example.com"
        verifier = described_class.new(email: no_ticket_email)

        expect(verifier.valid_ticket?).to be false
      end
    end

    context "when an API error occurs" do
      before do
        allow(Tito::TicketsFetcherService).to receive(:new).and_raise(Tito::ApiError.new("API failed"))
      end

      it "logs the error and returns false" do
        expect(Rails.logger).to receive(:error).with(/\[Tito::Verifier\] Error: API failed/)
        expect(subject.valid_ticket?).to be false
      end
    end
  end
end
