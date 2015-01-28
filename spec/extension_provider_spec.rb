require "spec_helper"

describe "postgresql_extension" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ["postgresql_extension"]) do |node|
      node.set["postgresql"]["extensions"] = [
        { name: "hstore", database: "foo-db" },
        { name: "uuid-ossp", database: "foo-db" },
        { name: "dblink", database: "bar-db", action: "drop" },
        { name: "another-test", database: "bar-db", action: "drop" }
      ]
    end.converge("postgresql::setup_extensions")
  end

  describe "create" do
    before do
      allow(Mixlib::ShellOut).to receive_messages(
        new: double(run_command: nil, exitstatus: 1)
      )
    end

    specify do
      expect(chef_run).to install_package "postgresql-contrib-9.4"

      expect(chef_run).to create_postgresql_extension("hstore").with(
        action: [:create],
        database: "foo-db"
      )
      expect(chef_run).to create_postgresql_extension("uuid-ossp").with(
        database: "foo-db"
      )

      expect(chef_run).to run_execute("create hstore extension").with(
        user: "postgres"
      )
      expect(chef_run).to run_execute(%(create "uuid-ossp" extension)).with(
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
      expect(chef_run).to drop_postgresql_extension("dblink").with(
        database: "bar-db"
      )
      expect(chef_run).to drop_postgresql_extension("another-test").with(
        database: "bar-db"
      )

      expect(chef_run).to run_execute("drop dblink extension").with(
        user: "postgres"
      )
      expect(chef_run).to run_execute(%(drop "another-test" extension)).with(
        user: "postgres"
      )
    end
  end
end
