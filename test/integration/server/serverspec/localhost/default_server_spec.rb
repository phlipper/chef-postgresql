require "spec_helper"

describe "PostgreSQL `apt` setup" do
  let(:apt_src){ "/etc/apt/sources.list.d/apt.postgresql.org.list" }
  let(:apt_pref){ "/etc/apt/preferences.d/pgdg.pref" }

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
