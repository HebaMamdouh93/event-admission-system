require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<TITO_API_TOKEN>') { ENV['TITO_API_TOKEN'] }
  config.allow_http_connections_when_no_cassette = false
end
