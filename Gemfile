source "https://rubygems.org"

gem "chef", "~> #{ENV.fetch("CHEF_VERSION", "12.0.3")}"
gem "chefspec", "~> 4.2.0"

gem "berkshelf", "~> 3.2.0"
gem "foodcritic", "~> 4.0.0"
gem "license_finder", "~> 1.2.0"
gem "rake"
gem "rubocop", "~> 0.28.0"
gem "serverspec", "~> 2.7.1"

group :integration do
  gem "busser-serverspec", "~> 0.5.3"
  gem "guard-rspec", "~> 4.5.0"
  gem "guard-rubocop", "~> 1.2.0"
  gem "kitchen-vagrant", "~> 0.15.0"
  gem "test-kitchen",
      git: "https://github.com/test-kitchen/test-kitchen.git",
      ref: "8e4ed89f405a2bf68cd51b7289dcadc783eadd2b"
end
