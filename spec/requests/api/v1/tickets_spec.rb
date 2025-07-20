require "rails_helper"

RSpec.describe "API::V1::Tickets", type: :request do
  let(:user) { create(:user) }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /api/v1/tickets/:id" do
    context "when the ticket exists and belongs to the user" do
      let(:ticket) { create(:ticket, user: user) }

      it "returns the ticket data" do
        get "/api/v1/tickets/#{ticket.id}", headers: headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Ticket retrieved successfully")
        expect(json["data"]["ticket"]["id"]).to eq(ticket.id)
      end
    end

    context "when the ticket does not exist or does not belong to user" do
      let(:other_user_ticket) { create(:ticket) }

      it "returns 404 not found" do
        get "/api/v1/tickets/#{other_user_ticket.id}", headers: headers

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Ticket not found")
      end
    end

    context "when user is unauthenticated" do
      it "returns 401 unauthorized" do
        get "/api/v1/tickets/1", headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
