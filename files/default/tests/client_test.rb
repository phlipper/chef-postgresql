require_relative "test_helper"

describe_recipe "postgresql::client" do
  let(:version) { node["postgresql"]["version"] }

  it "installed the `postgresql-client` package" do
    package("postgresql-client-#{version}").must_be_installed
  end
end
