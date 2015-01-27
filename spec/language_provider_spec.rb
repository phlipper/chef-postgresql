require "spec_helper"

describe "postgresql_language" do
  describe "create" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ["postgresql_language"]) do |node|
        node.set["postgresql"]["languages"] = [
          { name: "plpgsql", database: "foo-db" },
          { name: "plv8", database: "foo-db" },
          { name: "plperl", database: "foo-db" },
          { name: "plpython", database: "foo-db" },
          { name: "plpython3", database: "foo-db" }
        ]
      end.converge("postgresql::setup_languages")
    end

    before do
      allow(Mixlib::ShellOut).to receive_messages(
        new: double(run_command: nil, exitstatus: 1)
      )
    end

    specify do
      expect(chef_run).to install_package "postgresql-contrib-9.4"

      expect(chef_run).to create_postgresql_language("plpgsql").with(
        database: "foo-db"
      )
      expect(chef_run).to create_postgresql_language("plv8").with(
        database: "foo-db"
      )
      expect(chef_run).to create_postgresql_language("plperl").with(
        database: "foo-db"
      )
      expect(chef_run).to create_postgresql_language("plpython").with(
        database: "foo-db"
      )

      expect(chef_run).to run_execute("createlang plpgsql foo-db").with(
        user: "postgres"
      )

      expect(chef_run).to install_package "postgresql-9.4-plv8"
      expect(chef_run).to run_execute("createlang plv8 foo-db").with(
        user: "postgres"
      )

      expect(chef_run).to install_package "postgresql-plperl-9.4"
      expect(chef_run).to run_execute("createlang plperl foo-db").with(
        user: "postgres"
      )

      expect(chef_run).to install_package "postgresql-plpython-9.4"
      expect(chef_run).to run_execute("createlang plpythonu foo-db").with(
        user: "postgres"
      )

      expect(chef_run).to install_package "postgresql-plpython3-9.4"
      expect(chef_run).to run_execute("createlang plpython3u foo-db").with(
        user: "postgres"
      )
    end
  end

  describe "drop" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ["postgresql_language"]) do |node|
        node.set["postgresql"]["languages"] = [
          { name: "plpgsql", database: "bar-db", action: "drop" },
          { name: "plv8", database: "bar-db", action: "drop" },
          { name: "plperl", database: "bar-db", action: "drop" },
          { name: "plpython", database: "bar-db", action: "drop" },
          { name: "plpython3", database: "bar-db", action: "drop" }
        ]
      end.converge("postgresql::setup_languages")
    end

    before do
      allow(Mixlib::ShellOut).to receive_messages(
        new: double(run_command: nil, exitstatus: 0)
      )
    end

    specify do
      expect(chef_run).to drop_postgresql_language("plpgsql").with(
        database: "bar-db"
      )
      expect(chef_run).to drop_postgresql_language("plv8").with(
        database: "bar-db"
      )
      expect(chef_run).to drop_postgresql_language("plperl").with(
        database: "bar-db"
      )
      expect(chef_run).to drop_postgresql_language("plpython").with(
        database: "bar-db"
      )

      expect(chef_run).to run_execute("droplang plpgsql bar-db").with(
        user: "postgres"
      )

      expect(chef_run).to purge_package "postgresql-9.4-plv8"
      expect(chef_run).to run_execute("droplang plv8 bar-db").with(
        user: "postgres"
      )

      expect(chef_run).to purge_package "postgresql-plperl-9.4"
      expect(chef_run).to run_execute("droplang plperl bar-db").with(
        user: "postgres"
      )

      expect(chef_run).to purge_package "postgresql-plpython-9.4"
      expect(chef_run).to run_execute("droplang plpythonu bar-db").with(
        user: "postgres"
      )

      expect(chef_run).to purge_package "postgresql-plpython3-9.4"
      expect(chef_run).to run_execute("droplang plpython3u bar-db").with(
        user: "postgres"
      )
    end
  end
end
