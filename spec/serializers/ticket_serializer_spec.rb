# == Schema Information
#
# Table name: tickets
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  email            :string
#  name             :string
#  phone_number     :string
#  state            :string
#  tito_created_at  :datetime
#  tito_info        :jsonb
#  tito_ticket_slug :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tito_ticket_id   :integer
#  user_id          :bigint
#
# Indexes
#
#  index_tickets_on_deleted_at  (deleted_at)
#  index_tickets_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
