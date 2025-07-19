require "rails_helper"

RSpec.describe "API::V1::Auth::Sessions", type: :request do
  let(:user) { create(:user, password: "password123") }

  describe "POST /api/v1/auth/login" do
    context "with valid credentials" do
      it "returns a JWT token and user data" do
        post "/api/v1/auth/login", params: {
          email: user.email,
          password: "password123"
        }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["message"]).to eq("Logged in successfully")
        expect(json["data"]["token"]).to be_present
        expect(json["data"]["user"]["email"]).to eq(user.email)
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized error" do
        post "/api/v1/auth/login", params: {
          email: user.email,
          password: "wrong_password"
        }

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Invalid email or password")
      end
    end
  end

  describe "DELETE /api/v1/auth/logout" do
    it "returns a success message" do
      delete "/api/v1/auth/logout"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Logged out successfully")
    end
  end
end
