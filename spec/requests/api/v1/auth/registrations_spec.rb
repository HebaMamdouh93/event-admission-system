require "rails_helper"

RSpec.describe Api::V1::Auth::RegistrationsController, type: :request do
  let(:email) { "user@example.com" }
  let(:password) { "password123" }
  let(:valid_params) do
    {
      email: email,
      password: password,
      password_confirmation: password
    }
  end

  before do
    allow(Tito::TicketVerifierService).to receive(:new)
      .with(email: email)
      .and_return(double(valid_ticket?: ticket_valid))
 
  end

  context "when the user has a valid Tito ticket" do
    let(:ticket_valid) { true }

    it "registers the user successfully" do
      post "/api/v1/auth/register", params: valid_params
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Signed up successfully. Please confirm your email.")
    end
  end

  context "when the user does not have a valid Tito ticket" do
    let(:ticket_valid) { false }

    it "returns an error" do
      post "/api/v1/auth/register", params: valid_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["message"]).to eq("You must have a valid Tito ticket to register.")
    end
  end
end
