require "spec_helper"

describe "postgresql::client" do
  describe "version 9.3" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
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

  describe "version 9.4" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["postgresql"]["version"] = "9.4"
      end.converge(described_recipe)
    end

    it "includes the default recipe" do
      expect(chef_run).to include_recipe("postgresql::default")
    end

    it "installs the `postgresql-client-9.4` package" do
      expect(chef_run).to install_package("postgresql-client-9.4")
    end
  end
end
