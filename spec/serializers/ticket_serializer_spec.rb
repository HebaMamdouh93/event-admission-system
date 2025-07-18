require "rails_helper"

RSpec.describe TicketSerializer, type: :serializer do
  let(:ticket) { build_stubbed(:ticket) }

  context "serializes ticket info" do
    subject { described_class.new(ticket) }

    it "serializes ticket info" do
      serialized = JSON.parse(subject.to_json)
      expect(serialized["id"]).to eq(ticket.id)
      expect(serialized["email"]).to eq(ticket.email)
      expect(serialized["name"]).to eq(ticket.name)
      expect(serialized["phone_number"]).to eq(ticket.phone_number)
      expect(serialized["state"]).to eq(ticket.state)
      expect(serialized["tito_ticket_id"]).to eq(ticket.tito_ticket_id)
      expect(serialized["tito_ticket_slug"]).to eq(ticket.tito_ticket_slug)
    end
  end
end
