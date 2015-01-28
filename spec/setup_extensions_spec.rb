require "spec_helper"

describe "postgresql::setup_extensions" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["postgresql"]["extensions"] = [
        { name: "hstore", database: "foo-db" },
        { name: "plv8", database: "foo-db" },
        { name: "uuid-ossp", database: "foo-db", action: "drop" },
        { name: "test", database: "bar-db", action: "drop" },
        { name: "another-test", database: "bar-db" }
      ]
    end.converge(described_recipe)
  end

  specify do
    expect(chef_run).to include_recipe "postgresql::contrib"

    expect(chef_run).to create_postgresql_extension("hstore").with(
      database: "foo-db"
    )
    expect(chef_run).to create_postgresql_extension("plv8").with(
      database: "foo-db"
    )
    expect(chef_run).to drop_postgresql_extension("uuid-ossp").with(
      database: "foo-db"
    )

    expect(chef_run).to drop_postgresql_extension("test").with(
      database: "bar-db"
    )
    expect(chef_run).to create_postgresql_extension("another-test").with(
      database: "bar-db"
    )
  end
end
