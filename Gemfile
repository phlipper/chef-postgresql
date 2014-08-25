source "https://rubygems.org"

chef_version = ENV.fetch("CHEF_VERSION", "11.10")

gem "chef", "~> #{chef_version}"
gem "chefspec", "~> 4.0.0" if chef_version =~ /^11/

gem "berkshelf", "~> 3.1.3"
gem "foodcritic", "~> 4.0.0"
gem "rake"
gem "rubocop", "~> 0.25.0"
gem "serverspec", "~> 2.0.0.beta"

group :integration do
  gem "busser-serverspec", "~> 0.2.6"
  gem "guard-rspec", "~> 4.3.1"
  gem "kitchen-digitalocean", "~> 0.7.0"
  gem "kitchen-ec2", "~> 0.8.0"
  gem "kitchen-vagrant", "~> 0.15.0"
  gem "test-kitchen", "~> 1.2.1"
end
