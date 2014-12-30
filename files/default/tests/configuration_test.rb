require_relative "test_helper"

describe_recipe "postgresql::configuration" do
  let(:version) { node["postgresql"]["version"] }

  let(:template_paths) do
    {
      "environment" => "/etc/postgresql/#{version}/main/environment",
      "pg_ctl.conf" => "/etc/postgresql/#{version}/main/pg_ctl.conf",
      "pg_hba.conf" => "/etc/postgresql/#{version}/main/pg_hba.conf",
      "pg_ident.conf" => "/etc/postgresql/#{version}/main/pg_ident.conf",
      "postgresql.conf" => "/etc/postgresql/#{version}/main/postgresql.conf",
      "start.conf" => "/etc/postgresql/#{version}/main/start.conf"
    }
  end

  it "created the `main` configuration directory" do
    directory("/etc/postgresql/#{version}/main/").must_exist
      .with(:owner, "postgres").and(:group, "postgres")
  end

  it "created the `environment` file" do
    env_template = template_paths["environment"]

    file(env_template).must_exist
      .with(:owner, "postgres").and(:group, "postgres").and(:mode, "0644")
  end

  it "created the `pg_ctl.conf` file" do
    pg_ctl_template = template_paths["pg_ctl.conf"]

    file(pg_ctl_template).must_exist
      .with(:owner, "postgres").and(:group, "postgres").and(:mode, "0644")
  end

  it "created the `pg_hba.conf` file" do
    pg_hba_template = template_paths["pg_hba.conf"]

    file(pg_hba_template).must_exist
      .with(:owner, "postgres").and(:group, "postgres").and(:mode, "0640")
  end

  it "created the `pg_ident.conf` file" do
    pg_ident_template = template_paths["pg_ident.conf"]

    file(pg_ident_template).must_exist
      .with(:owner, "postgres").and(:group, "postgres").and(:mode, "0640")
  end

  it "created the `postgresql.conf` file" do
    postgresql_template = template_paths["postgresql.conf"]

    file(postgresql_template).must_exist
      .with(:owner, "postgres").and(:group, "postgres").and(:mode, "0644")
  end

  it "created the `start.conf` template" do
    start_template = template_paths["start.conf"]

    file(start_template).must_exist
      .with(:owner, "postgres").and(:group, "postgres").and(:mode, "0644")
  end
end
