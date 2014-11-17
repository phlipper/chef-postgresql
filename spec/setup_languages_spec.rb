require "spec_helper"

describe "postgresql::setup_languages" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["postgresql"]["languages"] = [
        { name: "plpgsql", database: "foo-db" },
        { name: "plv8", database: "foo-db" },
        { name: "plperl", database: "foo-db", action: "drop" }
      ]
    end.converge(described_recipe)
  end

  specify do
    expect(chef_run).to create_postgresql_language("plpgsql").with(
      database: "foo-db"
    )
    expect(chef_run).to create_postgresql_language("plv8").with(
      database: "foo-db"
    )
    expect(chef_run).to drop_postgresql_language("plperl").with(
      database: "foo-db"
    )
  end
end
