require "spec_helper"

describe "postgresql_database" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ["postgresql_database"]) do |node|
      node.set["postgresql"]["databases"] = [
        { name: "foo-db" },
        { name: "bar-db", action: "drop" }
      ]
    end.converge("postgresql::setup_databases")
  end

  describe "create" do
    before do
      allow(Mixlib::ShellOut).to receive_messages(
        new: double(run_command: nil, exitstatus: 1)
      )
    end

    specify do
      expect(chef_run).to create_postgresql_database "foo-db"

      expect(chef_run).to run_execute("create postgresql database foo-db").with(
        user: "postgres"
      )
    end
  end

  describe "drop" do
    before do
      allow(Mixlib::ShellOut).to receive_messages(
        new: double(run_command: nil, exitstatus: 0)
      )
    end

    specify do
      expect(chef_run).to drop_postgresql_database "bar-db"

      expect(chef_run).to run_execute("drop postgresql database bar-db").with(
        user: "postgres"
      )
    end
  end
end
