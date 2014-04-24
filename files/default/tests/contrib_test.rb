require_relative "test_helper"

describe_recipe "postgresql::contrib" do
  let(:version) { node["postgresql"]["version"] }

  it "installed the `postgresql-contrib` package" do
    package("postgresql-contrib-#{version}").must_be_installed
  end
end
