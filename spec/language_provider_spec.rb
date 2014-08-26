require "spec_helper"

describe "postgresql_language" do
  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ["postgresql_language"]) do |node|
      node.set["postgresql"]["languages"] = [
        { name: "plpgsql", database: "foo-db" },
        { name: "plv8", database: "foo-db" },
        { name: "plperl", database: "foo-db", action: "drop" }
      ]
    end.converge("postgresql::setup_languages")
  end

  describe "create" do
    before do
      allow(Mixlib::ShellOut).to receive_messages(
        new: double(run_command: nil, exitstatus: 1)
      )
    end

    specify do
      expect(chef_run).to create_postgresql_language("plpgsql").with(
        database: "foo-db"
      )
      expect(chef_run).to create_postgresql_language("plv8").with(
        database: "foo-db"
      )

      expect(chef_run).to run_execute("createlang plpgsql foo-db").with(
        user: "postgres"
      )
      expect(chef_run).to run_execute("createlang plv8 foo-db").with(
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
      expect(chef_run).to drop_postgresql_language("plperl").with(
        database: "foo-db"
      )

      expect(chef_run).to run_execute("droplang plperl foo-db").with(
        user: "postgres"
      )
    end
  end
end
