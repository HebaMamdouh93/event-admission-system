require "rails_helper"
require "swagger_helper"

RSpec.describe "API::V1::Profile", type: :request do
    let(:user) { create(:user) }
    let!(:ticket1) { create(:ticket, user: user) }
    let!(:ticket2) { create(:ticket, user: user) }
    let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
    let(:Authorization) { "Bearer #{token}" }
  path "/api/v1/profile" do
    get "Get current user profile" do
      tags "Profile"
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string

      response "200", "Profile retrieved successfully" do
     
        schema type: :object,
               properties: {
                 message: { type: :string, example: "Profile retrieved successfully" },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 1 },
                     email: { type: :string, example: "user@example.com" },
                     tickets: {
                       type: :array,
                       items: {
                         type: :object,
                         properties: {
                           id: { type: :integer, example: 1 },
                           tito_ticket_id: { type: :integer, example: 1234567890 },
                           state: { type: :string, example: "complete" },
                           email: { type: :string, example: "user@example.com" },
                           phone_number: { type: :string, example: "1234567890" },
                           name: { type: :string, example: "sdf gds"},
                           tito_ticket_slug: { type: :string, example: "ti_test_p2mLWs2lzdVBgdWPoHry6jw" }
                         }
                       }
                     }
                   }
                 }
               }

        

        run_test!
      end

      response "401", "Unauthorized" do
        let(:Authorization) { nil }
        schema type: :object,
               properties: {
                 message: { type: :string, example: "You need to sign in or sign up before continuing." },
                 errors: { type: :array, items: { type: :string } }
               }

        run_test!
      end
    end
  end
end
