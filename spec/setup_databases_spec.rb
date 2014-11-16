require "spec_helper"

describe "postgresql::setup_databases" do
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
