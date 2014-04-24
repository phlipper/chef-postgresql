require_relative "test_helper"

describe_recipe "postgresql::dbg" do
  let(:version) { node["postgresql"]["version"] }

  it "installed the `postgresql-dbg` package" do
    package("postgresql-#{version}-dbg").must_be_installed
  end
end
