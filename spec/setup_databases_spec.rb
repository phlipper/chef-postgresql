require "spec_helper"

describe "postgresql::setup_databases" do
  describe "with no database extensions present" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["postgresql"]["databases"] = [
          { name: "foo-db" },
          { name: "bar-db", action: "drop" }
        ]
      end.converge(described_recipe)
    end

    specify do
      expect(chef_run).to create_postgresql_database "foo-db"

      expect(chef_run).to drop_postgresql_database "bar-db"
    end
  end

  describe "with database extensions present" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["postgresql"]["databases"] = [
          { name: "baz-db", extensions: %w[hstore uuid-ossp] }
        ]
      end.converge(described_recipe)
    end

    specify do
      expect(chef_run).to create_postgresql_database "baz-db"
      expect(chef_run).to create_postgresql_extension("hstore").with(
        database: "baz-db"
      )
      expect(chef_run).to create_postgresql_extension("uuid-ossp").with(
        database: "baz-db"
      )
    end
  end

  describe "with database languagess present" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["postgresql"]["databases"] = [
          { name: "qux-db", languages: %w[plpgsql plperl] }
        ]
      end.converge(described_recipe)
    end

    specify do
      expect(chef_run).to create_postgresql_database "qux-db"
      expect(chef_run).to create_postgresql_language("plpgsql").with(
        database: "qux-db"
      )
      expect(chef_run).to create_postgresql_language("plperl").with(
        database: "qux-db"
      )
    end
  end
end
