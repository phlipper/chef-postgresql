begin
  require "chefspec"
  require "chefspec/berkshelf"
rescue LoadError
  puts "Unable to run `chefspec`"
  exit
end

RSpec.configure do |config|
  config.platform = "ubuntu"
  config.version = "12.04"
  config.log_level = :error
  config.raise_errors_for_deprecations!
end

def add_apt_repository(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :add, resource_name)
end

def add_apt_preference(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:apt_preference, :add, resource_name)
end

at_exit { ChefSpec::Coverage.report! }
