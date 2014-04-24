require_relative "test_helper"

describe_recipe "postgresql::doc" do
  let(:version) { node["postgresql"]["version"] }

  it "installed the `postgresql-doc` package" do
    package("postgresql-doc-#{version}").must_be_installed
  end
end
