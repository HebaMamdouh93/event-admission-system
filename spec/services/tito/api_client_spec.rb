require 'rails_helper'

RSpec.describe Tito::ApiClient, type: :service do
  let(:client) { described_class.new }

  describe "#list_tickets", :vcr do
    it "returns a list of tickets without search" do
      response = client.list_tickets
      expect(response.code).to eq(200)
      expect(response.parsed_response).to have_key("tickets")
    end

    it "returns tickets filtered by email" do
      response = client.list_tickets(search: "hebamamdouh2016@gmail.com")
      expect(response.code).to eq(200)
      expect(response.parsed_response).to have_key("tickets")
    end
  end

  describe "#ticket_details", :vcr do
    it "returns ticket details when slug is valid" do
      response = client.ticket_details("ti_test_pFjLxuUiofuiKdTgHhCQxyA")
      expect(response.code).to eq(200)
      expect(response.parsed_response).to have_key("ticket")
    end
  end

  describe "network error handling" do
    it "raises Tito::ApiError on SocketError" do
      allow(Tito::ApiClient).to receive(:get).and_raise(SocketError)
      expect { client.list_tickets }.to raise_error(Tito::ApiError, /Network error/)
    end
  end

  describe "API error handling", :vcr do
    it "raises Tito::ApiError on 404 response" do
      expect {
        client.ticket_details("non-existent-slug-xyz")
      }.to raise_error(Tito::ApiError)
    end
  end
end
