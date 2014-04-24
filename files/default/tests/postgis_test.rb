require_relative "test_helper"

describe_recipe "postgresql::postgis" do
  let(:pg_version) { node["postgresql"]["version"] }
  let(:postgis_version) { node["postgis"]["version"] }

  it "installed the `postgresql-postgis` package" do
    pkg_name = "postgresql-#{pg_version}-postgis-#{postgis_version}"
    package(pkg_name).must_be_installed
  end
end
