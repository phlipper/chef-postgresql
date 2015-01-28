require "spec_helper"

describe "postgresql::default" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it "adds an apt preference" do
    expect(chef_run).to add_apt_preference("pgdg")
  end

  it "sets up an apt repository" do
    expect(chef_run).to include_recipe("postgresql::apt_repository")
  end

  it "does not set up an `debian-backports`" do
    expect(chef_run).to_not include_recipe("postgresql::debian_backports")
  end

  # debian family setup
  context "using debian platform" do
    let(:chef_run) do
      env_options = { platform: "debian", version: "6.0.5" }
      ChefSpec::SoloRunner.new(env_options).converge(described_recipe)
    end

    it "sets up an apt repository" do
      expect(chef_run).to include_recipe("postgresql::apt_repository")
    end

    it "sets up an `debian-backports`" do
      expect(chef_run).to include_recipe("postgresql::debian_backports")
    end
  end
end
