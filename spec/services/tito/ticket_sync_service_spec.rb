require "rails_helper"

RSpec.describe Tito::TicketSyncService do
  let(:ticket_data) do
    file_path = Rails.root.join("spec/fixtures/tito_ticket.json")
    JSON.parse(File.read(file_path))
  end

  describe "#call" do
    context "when the ticket does not exist" do
      it "creates a new ticket with correct attributes" do
        expect {
          described_class.new(ticket_data).call
        }.to change(Ticket, :count).by(1)

        ticket = Ticket.find_by(tito_ticket_id: ticket_data["id"])
        expect(ticket.tito_ticket_id).to eq(ticket_data["id"])
        expect(ticket.tito_ticket_slug).to eq(ticket_data["slug"])
        expect(ticket.name).to eq(ticket_data["name"])
        expect(ticket.email).to eq(ticket_data["email"])
        expect(ticket.phone_number).to eq(ticket_data["phone_number"])
      end
    end

    context "when the ticket already exists" do
      let!(:existing_ticket) { create(:ticket, tito_ticket_id: ticket_data["id"], tito_ticket_slug: ticket_data["slug"]) }

      it "updates the existing ticket" do
        described_class.new(ticket_data).call
        existing_ticket.reload
        expect(existing_ticket.email).to eq(ticket_data["email"])
        expect(existing_ticket.name).to eq(ticket_data["name"])
      end
    end
  end
end
