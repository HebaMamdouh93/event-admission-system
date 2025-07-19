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
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  # Devise validations
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should allow_value("user@example.com").for(:email) }

  # Associations
  it { should have_many(:tickets).dependent(:nullify) }

  # Scopes
  describe ".by_email" do
    let!(:user) { create(:user, email: "test@example.com") }

    it "returns user matching the given email" do
      expect(User.by_email("test@example.com")).to include(user)
    end

    it "returns empty result for unmatched email" do
      expect(User.by_email("missing@example.com")).to be_empty
    end
  end

  # Callbacks
  describe "#after_confirmation" do
    let!(:ticket) { create(:ticket, email: "linked@example.com", user_id: nil) }
    let(:user) { create(:user, email: "linked@example.com", confirmed_at: nil) }

    it "assigns unlinked tickets after confirmation" do
      user.confirm
      expect(ticket.reload.user_id).to eq(user.id)
    end
  end
end

