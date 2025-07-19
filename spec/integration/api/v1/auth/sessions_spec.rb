require "swagger_helper"

RSpec.describe "API::V1::Auth::Sessions", type: :request do
  path "/api/v1/auth/login" do
    post "User Login" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        required: %w[email password],
        properties: {
          email: { type: :string, example: "user@example.com" },
          password: { type: :string, example: "password123" }
        }
      }

      response "200", "User logged in successfully" do
        let(:user) { create(:user, password: "password123") }

        let(:credentials) do
          {
            email: user.email,
            password: "password123"
          }
        end

        schema type: :object,
               properties: {
                 message: { type: :string, example: "Logged in successfully" },
                 data: {
                   type: :object,
                   properties: {
                     token: { type: :string, example: "eyJhbGciOiJIUzI1..." },
                     user: {
                       type: :object,
                       properties: {
                         id: { type: :integer, example: 1 },
                         email: { type: :string, example: "user@example.com" }
                       }
                     }
                   }
                 }
               }

        run_test!
      end

      response "401", "Invalid credentials" do
        let(:credentials) do
          {
            email: "wrong@example.com",
            password: "wrong_password"
          }
        end

        schema type: :object,
               properties: {
                 message: { type: :string, example: "Invalid email or password" },
                 errors: { type: :array, items: { type: :string }, nullable: true }
               }

        run_test!
      end
    end
  end

  path "/api/v1/auth/logout" do
    delete "User Logout" do
      tags "Authentication"
      produces "application/json"

      response "200", "User logged out successfully" do
        schema type: :object,
               properties: {
                 message: { type: :string, example: "Logged out successfully" },
                 data: { type: :object, nullable: true }
               }

        run_test!
      end
    end
  end
end
