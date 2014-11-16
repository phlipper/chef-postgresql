require "spec_helper"

describe "postgresql::debian_backports" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it "sets up an apt repository for `debian-backports`" do
    expect(chef_run).to add_apt_repository("debian-backports")
  end

  it "installs the `libpq5` package" do
    expect(chef_run).to install_package("libpq5")
  end

  it "installs the `postgresql-common` package" do
    expect(chef_run).to install_package("postgresql-common")
  end
end
