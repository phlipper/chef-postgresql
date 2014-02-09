require "spec_helper"

describe "postgresql::postgis" do
  let(:chef_run) do
    ChefSpec::Runner.new{ |node|
      node.set["postgresql"]["version"] = "9.3"
      node.set["postgis"]["version"] = "2.1"
    }.converge(described_recipe)
  end

  it "includes the default recipe" do
    expect(chef_run).to include_recipe("postgresql::default")
  end

  it "installs the `postgresql-9.3-postgis-2.1` package" do
    expect(chef_run).to install_package("postgresql-9.3-postgis-2.1")
  end
end
