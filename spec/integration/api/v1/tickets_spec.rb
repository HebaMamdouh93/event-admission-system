require "swagger_helper"

RSpec.describe "API::V1::Tickets", type: :request do
  path "/api/v1/tickets/{id}" do
    get "Get ticket details" do
      tags "Tickets"
      security [Bearer: []]
      produces "application/json"
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :Authorization, in: :header, type: :string

      response "200", "Ticket retrieved successfully" do
        let(:user) { create(:user) }
        let(:ticket) { create(:ticket, user: user) }
        let(:id) { ticket.id }
        let(:Authorization) do
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          "Bearer #{token}"
        end

        schema type: :object,
               properties: {
                 message: { type: :string, example: "Ticket retrieved successfully" },
                 data: {
                   type: :object,
                   properties: {
                     ticket: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         tito_ticket_id: { type: :integer },
                         tito_ticket_slug: { type: :string },
                         email: { type: :string },
                         name: { type: :string },
                         phone_number: { type: :string },
                         state: { type: :string }
                       }
                     }
                   }
                 }
               }

        run_test!
      end

      response "404", "Ticket not found" do
        let(:user) { create(:user) }
        let(:id) { 999999 } 
        let(:Authorization) do
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          "Bearer #{token}"
        end

        schema type: :object,
               properties: {
                 message: { type: :string, example: "Ticket not found" }
               }

        run_test!
      end

      response "401", "Unauthorized" do
        let(:id) { 1 }
        let(:Authorization) { nil }

        schema type: :object,
               properties: {
                 message: { type: :string, example: "You need to sign in or sign up before continuing." }
               }

        run_test!
      end
    end
  end
end
