require "rails_helper"

RSpec.describe UserSerializer, type: :serializer do
  let(:ticket1) { build_stubbed(:ticket) }
  let(:ticket2) { build_stubbed(:ticket) }
  let(:user)    { build_stubbed(:user, tickets: [ticket1, ticket2]) }

  context "without including tickets" do
    subject { described_class.new(user) }

    it "serializes id and email only" do
      serialized = JSON.parse(subject.to_json)
      expect(serialized["id"]).to eq(user.id)
      expect(serialized["email"]).to eq(user.email)
      expect(serialized).not_to have_key("tickets")
    end
  end

  context "with tickets included" do
    subject { described_class.new(user, include_tickets: true) }

    it "serializes tickets with user" do
      serialized = JSON.parse(subject.to_json)
      expect(serialized["id"]).to eq(user.id)
      expect(serialized["email"]).to eq(user.email)
      expect(serialized).to have_key("tickets")
      expect(serialized["tickets"].size).to eq(2)
    end
  end
end
