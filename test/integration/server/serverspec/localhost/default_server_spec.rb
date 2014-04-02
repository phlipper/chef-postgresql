require "spec_helper"

describe "PostgreSQL `apt` setup" do
  let(:apt_src){ "/etc/apt/sources.list.d/apt.postgresql.org.list" }
  let(:apt_pref){ "/etc/apt/preferences.d/pgdg.pref" }

  it "sets up default apt preferences" do
    expect(file apt_pref).to be_file
    expect(file apt_pref).to contain("Package: *")
    expect(file apt_pref).to contain("Pin: release o=apt.postgresql.org")
  end

  it "sets up the primay apt repository" do
    expect(file apt_src).to be_file
    expect(file apt_src).to contain("apt.postgresql.org")
    expect(file apt_src).to contain("pgdg main")
  end
end

describe "Package installation" do
  it { expect(package "postgresql-common").to be_installed }
  it { expect(package "postgresql-9.3").to be_installed }
  it { expect(package "postgresql-client-9.3").to be_installed }
  it { expect(package "postgresql-contrib-9.3").to be_installed }
  it { expect(package "postgresql-9.3-dbg").to be_installed }
  it { expect(package "postgresql-doc-9.3").to be_installed }
  it { expect(package "libpq5").to be_installed }
  it { expect(package "libpq-dev").to be_installed }
  it { expect(package "postgresql-server-dev-9.3").to be_installed }
end

describe "PostgreSQL server installation" do
  let(:config_path){ "/etc/postgresql/9.3/main" }
  let(:hba_contents) do
    "local   all             postgres                                peer"
  end

  it "manages the `postgresql` service" do
    expect(service "postgresql").to be_enabled
    # expect(service "postgresql").to be_running
    expect(command "pgrep postgres").to return_stdout(/\d+/)
  end

  it "listens on the default port" do
    expect(port 5432).to be_listening
  end

  it "configures a default `postgresql.conf`" do
    expect(file "#{config_path}/postgresql.conf").to be_a_file
    expect(file "#{config_path}/postgresql.conf").to contain(
      %|hba_file = '/etc/postgresql/9.3/main/pg_hba.conf'|
    )
  end

  it "configures a default `pg_hba.conf`" do
    expect(file "#{config_path}/pg_hba.conf").to be_a_file
    # expect(file "#{config_path}/pg_hba.conf").to contain(
    expect(command "sudo grep '#{hba_contents}' #{config_path}/pg_hba.conf").to(
      return_stdout(hba_contents)
    )
  end
end

describe "PostgreSQL users, databases, and extensions" do
  it "creates the `testuser` user" do
    database_role_exists? "testuser"
  end

  it "creates the `testdb` database" do
    database_exists? "testdb"
  end

  %w[dblink hstore uuid-ossp].each do |extension|
    it "creates the `#{extension}` database extension" do
      database_extension_exists? "testdb", extension
    end
  end
end
