require "swagger_helper"

RSpec.describe "API::V1::Auth::Registrations", type: :request do
  path "/api/v1/auth/register" do
    post "User Registration" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: "user@example.com" },
          password: { type: :string, example: "password123" },
          password_confirmation: { type: :string, example: "password123" }
        },
        required: %w[email password password_confirmation]
      }

      response "200", "User registered successfully" do
        let(:user) do
          {
            email: "user@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        end

        before do
          allow(Tito::TicketVerifierService).to receive(:new).and_return(double(valid_ticket?: true))
        end
        schema type: :object,
             properties: {
               message: { type: :string, example: "Signed up successfully. Please confirm your email." }
             }

        run_test!
      end

      response "422", "User registration failed" do
        let(:user) do
          {
            email: "user@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        end

        before do
          allow(Tito::TicketVerifierService).to receive(:new).and_return(double(valid_ticket?: false))
        end

        schema type: :object,
               properties: {
                 message: { type: :string, example: "You must have a valid Tito ticket to register." },
                 errors: {
                   type: :array,
                   items: { type: :string },
                   example: []
                 }
               }

        run_test!
      end
    end
  end
end
