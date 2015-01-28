require "spec_helper"

describe "postgresql::server" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["postgresql"]["version"] = "9.3"
    end.converge(described_recipe)
  end

  before do
    stub_command("pgrep postgres").and_return(false)
    stub_command("test -f /var/lib/postgresql/9.3/main/PG_VERSION")
      .and_return(false)
  end

  it "includes the default recipe" do
    expect(chef_run).to include_recipe("postgresql::default")
  end

  context "auto-start for the service to allow custom configuration" do
    context "postgres is not already running" do
      it "prevents auto-start" do
        expect(chef_run).to create_file("/usr/sbin/policy-rc.d").with(
          mode: "0755",
          content: "#!/bin/sh\nexit 101\n"
        )
      end
    end

    context "postgres is already running" do
      before do
        stub_command("pgrep postgres").and_return(true)
      end

      it "does not prevent auto-start" do
        expect(chef_run).to_not create_file("/usr/sbin/policy-rc.d")
      end
    end
  end

  specify do
    expect(chef_run).to install_package("postgresql-9.3")

    expect(chef_run).to include_recipe("postgresql::data_directory")
    expect(chef_run).to include_recipe("postgresql::configuration")
    expect(chef_run).to include_recipe("postgresql::service")

    expect(chef_run).to include_recipe("postgresql::setup_users")
    expect(chef_run).to include_recipe("postgresql::setup_databases")
    expect(chef_run).to include_recipe("postgresql::setup_extensions")
    expect(chef_run).to include_recipe("postgresql::setup_languages")
  end
end
