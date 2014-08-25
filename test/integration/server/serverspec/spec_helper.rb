require "serverspec"
require "pathname"

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.os = backend(Serverspec::Commands::Base).check_os
  end
end

def database_role_exists?(role)
  cmd = "sudo -u postgres "
  cmd << %(psql -c "SELECT rolname FROM pg_roles WHERE rolname='#{role}'")
  cmd << " | grep #{role}"

  expect(command cmd).to return_exit_status(0)
end

def database_exists?(database)
  expect(command %(sudo -u postgres psql -l | grep #{database})).to be_truthy
end

def database_extension_exists?(database, extension)
  cmd = %(sudo -u postgres psql -c "\\dx" #{database} | grep #{extension})
  expect(command cmd).to return_exit_status(0)
end
