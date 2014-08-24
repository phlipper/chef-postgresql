require "spec_helper"

describe "postgresql::pg_database" do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set["postgresql"]["databases"] = [
        {
          name: "foo-db",
          extensions: %w[hstore uuid-ossp],
          postgis: true,
          languages: "plpgsql"
        }
      ]
    end.converge(described_recipe)
  end

  specify do
    expect(chef_run).to include_recipe "postgresql::contrib"

    expect(chef_run).to create_postgresql_database "foo-db"

    expect(chef_run).to create_postgresql_extension "hstore"
    expect(chef_run).to create_postgresql_extension "uuid-ossp"

    expect(chef_run).to create_postgresql_extension "postgis"
    expect(chef_run).to create_postgresql_extension "postgis_topology"

    expect(chef_run).to create_postgresql_language "plpgsql"
  end

  describe "with no extensions" do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set["postgresql"]["databases"] = [
          { name: "foo-db" }
        ]
      end.converge(described_recipe)
    end

    specify do
      expect(chef_run).to_not include_recipe "postgresql::contrib"

      expect(chef_run).to create_postgresql_database "foo-db"

      expect(chef_run).to_not create_postgresql_extension "hstore"
      expect(chef_run).to_not create_postgresql_extension "uuid-ossp"

      expect(chef_run).to_not create_postgresql_extension "postgis"
      expect(chef_run).to_not create_postgresql_extension "postgis_topology"

      expect(chef_run).to_not create_postgresql_language "plpgsql"
    end
  end
end
