require "rails_helper"

RSpec.describe SyncTitoTicketsPageJob, type: :job do
  let(:page) { 1 }

  let(:tickets_fixture) { load_fixture("tito_tickets.json") }

  let(:ticket_data_1) { tickets_fixture['tickets'][0] }
  let(:ticket_data_2) { tickets_fixture['tickets'][1] }

  describe "#perform" do
    context "when tickets are returned for the page" do
      before do
        allow_any_instance_of(Tito::TicketsFetcherService)
          .to receive(:call)
          .and_return([ [ ticket_data_1, ticket_data_2 ], nil ]) # simulates [tickets, meta]

        allow(Tito::TicketSyncService).to receive(:new).and_call_original
      end

      it "calls TicketSyncService for each ticket" do
        expect(Tito::TicketSyncService).to receive(:new).with(ticket_data_1).and_call_original
        expect(Tito::TicketSyncService).to receive(:new).with(ticket_data_2).and_call_original

        described_class.perform_now(page)
      end
    end

    context "when no tickets are returned" do
      before do
        allow_any_instance_of(Tito::TicketsFetcherService)
          .to receive(:call)
          .and_return([ [], nil ])
      end

      it "does nothing" do
        expect(Tito::TicketSyncService).not_to receive(:new)
        described_class.perform_now(page)
      end
    end
  end
end
