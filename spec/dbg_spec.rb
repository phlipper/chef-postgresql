require "spec_helper"

describe "postgresql::dbg" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["postgresql"]["version"] = "9.3"
    end.converge(described_recipe)
  end

  it "includes the default recipe" do
    expect(chef_run).to include_recipe("postgresql::default")
  end

  it "installs the `postgresql-9.3-dbg` package" do
    expect(chef_run).to install_package("postgresql-9.3-dbg")
  end
end
