require "spec_helper"

describe "PostgreSQL `apt` setup" do
  let(:apt_src) do
    "/etc/apt/sources.list.d/apt.postgresql.org.list"
  end

  let(:apt_pref) do
    "/etc/apt/preferences.d/pgdg.pref"
  end

  it "set up default apt preferences" do
    expect(file apt_pref).to be_file
    expect(file apt_pref).to contain("Package: *")
    expect(file apt_pref).to contain("Pin: release o=apt.postgresql.org")
  end

  it "set up the primay apt repository" do
    expect(file apt_src).to be_file
    expect(file apt_src).to contain("apt.postgresql.org")
    expect(file apt_src).to contain("pgdg main")
  end
end

describe "Package installation" do
  version = "9.3"
  packages = %w[
    postgresql-common postgresql-%s postgresql-client-%s postgresql-contrib-%s
    postgresql-%s-dbg postgresql-doc-%s libpq5 libpq-dev
    postgresql-server-dev-%s
  ].map { |pkg| pkg % version }

  packages.each do |pkg|
    it "installed the `#{pkg}` package" do
      expect(package pkg).to be_installed
    end
  end
end

describe "PostgreSQL server installation" do
  let(:config_path) do
    "/etc/postgresql/9.3/main"
  end

  let(:hba_contents) do
    "local   all             postgres                                peer"
  end

  it "managed the `postgresql` service" do
    expect(service "postgresql").to be_enabled
    expect(service "postgresql").to be_running
    expect(command "pgrep postgres").to return_stdout(/\d+/)
  end

  it "listened on the default port" do
    expect(port 5432).to be_listening
  end

  it "configured a default `postgresql.conf`" do
    expect(file "#{config_path}/postgresql.conf").to be_a_file
    expect(file "#{config_path}/postgresql.conf").to contain(
      %(hba_file = '/etc/postgresql/9.3/main/pg_hba.conf')
    )
  end

  it "configured a default `pg_hba.conf`" do
    expect(file "#{config_path}/pg_hba.conf").to be_a_file
    expect(file "#{config_path}/pg_hba.conf").to contain(hba_contents)
  end
end

describe "PostgreSQL users, databases, and extensions" do
  it "created the `testuser` user" do
    database_role_exists? "testuser"
  end

  it "created the `testdb` database" do
    database_exists? "testdb"
  end

  %w[dblink hstore uuid-ossp].each do |extension|
    it "created the `#{extension}` database extension" do
      database_extension_exists? "testdb", extension
    end
  end
end
