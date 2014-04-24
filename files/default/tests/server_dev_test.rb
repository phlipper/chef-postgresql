require_relative "test_helper"

describe_recipe "postgresql::server_dev" do
  let(:version) { node["postgresql"]["version"] }

  it "installed the `postgresql-server-dev` package" do
    package("postgresql-server-dev-#{version}").must_be_installed
  end
end
