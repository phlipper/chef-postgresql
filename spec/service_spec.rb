require "spec_helper"

describe "postgresql::service" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["postgresql"]["version"] = "9.3"
    end.converge(described_recipe)
  end

  it "cleans up the `policy-rc.d` file" do
    expect(chef_run).to delete_file("/usr/sbin/policy-rc.d")
  end

  it "defines the `postgresql` service" do
    expect(chef_run).to enable_service("postgresql")
    expect(chef_run).to start_service("postgresql")
  end
end
