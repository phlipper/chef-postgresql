require "spec_helper"

describe "postgresql::postgis" do
  describe "debian" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: "debian",
        version: "7.2"
      ).converge(described_recipe)
    end

    let(:log_message) do
      "The `postgis` recipe is not available for Debian at this time"
    end

    it "does not include the default recipe" do
      expect(chef_run).to_not include_recipe("postgresql::default")
    end

    it "logs a warning message" do
      expect(chef_run).to write_log(log_message).with(level: :warn)
    end
  end

  describe "ubuntu" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["postgresql"]["version"] = "9.3"
        node.set["postgis"]["version"] = "2.1"
      end.converge(described_recipe)
    end

    it "includes the default recipe" do
      expect(chef_run).to include_recipe("postgresql::default")
    end

    it "installs the `postgresql-9.3-postgis-2.1` package" do
      expect(chef_run).to install_package("postgresql-9.3-postgis-2.1")
    end
  end
end
