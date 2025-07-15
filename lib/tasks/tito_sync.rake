namespace :tito do
  # rake tito:sync_tickets
  desc "Sync Tito tickets"
  task sync_tickets: :environment do
    SyncTitoTicketsJob.perform_later
    puts "Tito ticket sync job enqueued."
  end
end
