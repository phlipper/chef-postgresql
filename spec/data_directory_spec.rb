require "spec_helper"

describe "postgresql::data_directory" do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set["postgresql"]["version"] = "9.3"
    end.converge(described_recipe)
  end

  context "the data directory does not already exist" do
    before do
      stub_command("test -f /var/lib/postgresql/9.3/main/PG_VERSION")
        .and_return(false)
    end

    it "creates the data directory" do
      expect(chef_run).to create_directory("/var/lib/postgresql/9.3/main").with(
        owner:  "postgres",
        group:  "postgres",
        mode:   "0700",
        recursive: true
      )
    end

    it "executes `initdb`" do
      expect(chef_run).to run_bash("postgresql initdb")
    end
  end

  context "the data directory already exists" do
    before do
      stub_command("test -f /var/lib/postgresql/9.3/main/PG_VERSION")
        .and_return(true)
    end

    it "creates the data directory" do
      expect(chef_run).to_not create_directory("/var/lib/postgresql/9.3/main")
    end

    it "does not execute `initdb`" do
      expect(chef_run).to_not run_bash("postgresql initdb")
    end
  end
end
