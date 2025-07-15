require "rails_helper"

RSpec.describe Tito::TicketsFetcherService, :vcr do
  describe "#call" do
    context "when tickets exist on the given page" do
      it "returns an array of ticket hashes" do
        result = described_class.new(page: 1).call

        expect(result[0]).to be_an(Array)
        expect(result[0].first).to include("id", "email")
      end
    end

    context "when there are no tickets on a high page number" do
      it "returns an empty array" do
        result = described_class.new(page: 999).call
        expect(result[0]).to eq([])
      end
    end
  end
end
