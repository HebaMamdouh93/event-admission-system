require "rails_helper"

RSpec.describe SyncTitoTicketsJob, type: :job do
  describe "#perform" do
    let(:fixture_data) { load_fixture("tito_tickets.json") }

    let(:tickets) { fixture_data["tickets"] }
    let(:meta)    { fixture_data["meta"] }

    context "when tickets are returned and meta includes total_pages" do
      before do
        allow_any_instance_of(Tito::TicketsFetcherService)
          .to receive(:call)
          .and_return([ tickets, meta ])
      end

      it "schedules SyncTitoTicketsPageJob for each page" do
        expect(SyncTitoTicketsPageJob).to receive(:perform_later).with(1)
        expect(SyncTitoTicketsPageJob).to receive(:perform_later).with(2)
        expect(SyncTitoTicketsPageJob).to receive(:perform_later).with(3)

        described_class.perform_now
      end
    end

    context "when no tickets are returned" do
      before do
        allow_any_instance_of(Tito::TicketsFetcherService)
          .to receive(:call)
          .and_return([ [], { "total_pages" => 1 } ])
      end

      it "does not enqueue any page jobs" do
        expect(SyncTitoTicketsPageJob).not_to receive(:perform_later)
        described_class.perform_now
      end
    end
  end
end
