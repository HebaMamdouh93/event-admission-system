module FixtureHelper
  def load_fixture(name)
    JSON.parse(File.read(Rails.root.join("spec/fixtures", name)))
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
