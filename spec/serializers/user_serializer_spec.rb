# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
