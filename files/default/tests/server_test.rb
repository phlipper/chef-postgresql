require_relative "test_helper"

describe_recipe "postgresql::server" do
  let(:version) { node["postgresql"]["version"] }

  it "installed the `postgresql` package" do
    package("postgresql-#{version}").must_be_installed
  end
end
