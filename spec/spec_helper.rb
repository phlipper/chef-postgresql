require "chefspec"
require "chefspec/berkshelf"

RSpec.configure do |config|
  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = "ubuntu"

  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = "12.04"

  # Specify the Chef log_level (default: :warn)
  config.log_level = :error
end

def add_apt_repository(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :add, resource_name)
end

def add_apt_preference(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:apt_preference, :add, resource_name)
end

at_exit { ChefSpec::Coverage.report! }
