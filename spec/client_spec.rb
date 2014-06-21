require "spec_helper"

describe "postgresql::client" do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set["postgresql"]["version"] = "9.3"
    end.converge(described_recipe)
  end

  it "includes the default recipe" do
    expect(chef_run).to include_recipe("postgresql::default")
  end

  it "installs the `postgresql-client-9.3` package" do
    expect(chef_run).to install_package("postgresql-client-9.3")
  end
end
