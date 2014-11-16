require "spec_helper"

describe "postgresql::libpq" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it "includes the default recipe" do
    expect(chef_run).to include_recipe("postgresql::default")
  end

  it "installs the `libpq5` package" do
    expect(chef_run).to install_package("libpq5")
  end

  it "installs the `libpq-dev` package" do
    expect(chef_run).to install_package("libpq-dev")
  end
end
