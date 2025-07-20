require "rails_helper"

RSpec.describe "Api::V1::Profile", type: :request do
  describe "GET /api/v1/profile" do
    let(:user) { create(:user) }
    let!(:tickets) { create_list(:ticket, 2, user: user) }
    let(:auth_headers) do
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      { "Authorization" => "Bearer #{token}" }
    end

    context "when authenticated" do
      it "returns the user profile with tickets" do
        get "/api/v1/profile", headers: auth_headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Profile retrieved successfully")
        expect(json["data"]["id"]).to eq(user.id)
        expect(json["data"]["email"]).to eq(user.email)
        expect(json["data"]["tickets"].size).to eq(2)
      end
    end

    context "when unauthenticated" do
      it "returns 401 unauthorized" do
        get "/api/v1/profile", headers: { "Accept" => "application/json" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
