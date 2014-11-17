require "spec_helper"

describe "postgresql::apt_repository" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it "sets up an apt repository for `apt.postgresql.org`" do
    expect(chef_run).to add_apt_repository("apt.postgresql.org")
  end

  it "installs the `pgdg-keyring` package" do
    expect(chef_run).to install_package("pgdg-keyring")
  end
end
