require "spec_helper"

describe "postgresql::setup_languages" do
  let(:languages) do
    %w[plperl plpgsql plpython plpython3 plv8]
  end

  describe "create languages" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["postgresql"]["languages"] = [
          { name: "plperl", database: "foo-db" },
          { name: "plpgsql", database: "foo-db" },
          { name: "plpython", database: "foo-db" },
          { name: "plpython3", database: "foo-db" },
          { name: "plv8", database: "foo-db" }
        ]
      end.converge(described_recipe)
    end

    let(:db_opts) do
      { database: "foo-db" }
    end

    specify do
      languages.each do |lang|
        expect(chef_run).to create_postgresql_language(lang).with(db_opts)
      end
    end
  end

  describe "drop languages" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set["postgresql"]["languages"] = [
          { name: "plperl", database: "bar-db", action: "drop" },
          { name: "plpgsql", database: "bar-db", action: "drop" },
          { name: "plpython", database: "bar-db", action: "drop" },
          { name: "plpython3", database: "bar-db", action: "drop" },
          { name: "plv8", database: "bar-db", action: "drop" }
        ]
      end.converge(described_recipe)
    end

    let(:db_opts) do
      { database: "bar-db" }
    end

    specify do
      languages.each do |lang|
        expect(chef_run).to drop_postgresql_language(lang).with(db_opts)
      end
    end
  end
end
