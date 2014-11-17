require "spec_helper"

describe "postgresql::data_directory" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["postgresql"]["version"] = "9.3"
    end.converge(described_recipe)
  end

  context "the data directory does not already exist" do
    specify do
      expect(chef_run).to create_directory("/var/lib/postgresql/9.3/main").with(
        owner:  "postgres",
        group:  "postgres",
        mode:   "0700",
        recursive: true
      )

      expect(chef_run).to run_bash("postgresql initdb")
    end
  end

  context "the data directory already exists" do
    before do
      allow(::File).to receive_messages(:exist? => true)
    end

    specify do
      expect(chef_run).to_not create_directory("/var/lib/postgresql/9.3/main")
      expect(chef_run).to_not run_bash("postgresql initdb")
    end
  end
end
