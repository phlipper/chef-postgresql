require "spec_helper"

describe "PostgreSQL `apt` setup" do
  describe file("/etc/apt/preferences.d/pgdg.pref") do
    it { should be_a_file }
    its(:content) { should match("Package: *") }
    its(:content) { should match("Pin: release o=apt.postgresql.org") }
  end

  describe file("/etc/apt/sources.list.d/apt.postgresql.org.list") do
    it { should be_a_file }
    its(:content) { should match("apt.postgresql.org") }
    its(:content) { should match("pgdg main") }
  end
end

describe "Package installation" do
  version = "9.4"
  packages = %w[
    postgresql-common postgresql-%s postgresql-client-%s postgresql-contrib-%s
    postgresql-%s-dbg postgresql-doc-%s libpq5 libpq-dev
    postgresql-server-dev-%s
  ].map { |pkg| pkg % version }

  packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe "PostgreSQL server installation" do
  describe service("postgresql") do
    it { should be_enabled }
    it { should be_running }
  end

  describe command("pgrep postgres") do
    its(:stdout) { should match(/\d+/) }
    its(:exit_status) { should eq 0 }
  end

  describe port(5432) do
    it { should be_listening }
  end

  describe file("/etc/postgresql/9.4/main/postgresql.conf") do
    it { should be_a_file }
    its(:content) do
      should match %(hba_file = '/etc/postgresql/9.4/main/pg_hba.conf')
    end
  end

  describe file("/etc/postgresql/9.4/main/pg_hba.conf") do
    it { should be_a_file }
    its(:content) { should match(/local\s+all\s+postgres\s+peer/) }
  end
end

describe "PostgreSQL users, databases, and extensions" do
  describe command(cmd_role_exists("testuser")) do
    its(:stdout) { should match "testuser" }
    its(:exit_status) { should eq 0 }
  end

  describe command(cmd_role_exists("fakeuser")) do
    its(:stdout) { should_not match "fakeuser" }
    its(:exit_status) { should eq 1 }
  end

  describe command(cmd_database_exists("testdb")) do
    its(:exit_status) { should eq 0 }
  end

  describe command(cmd_database_exists("fakedb")) do
    its(:exit_status) { should eq 1 }
  end

  installed_extensions = %w[
    adminpack autoinc btree_gin btree_gist chkpass citext cube dblink dict_int
    dict_xsyn earthdistance file_fdw fuzzystrmatch hstore insert_username intagg
    intarray isn lo ltree moddatetime pageinspect pg_buffercache pg_freespacemap
    pg_prewarm pg_stat_statements pg_trgm pgcrypto pgrowlocks pgstattuple
    postgres_fdw refint seg sslinfo tablefunc tcn test_parser test_shm_mq
    timetravel tsearch2 unaccent uuid-ossp worker_spi xml2
  ]
  installed_extensions.each do |extension|
    describe command(cmd_extension_exists("testdb", extension)) do
      its(:stdout) { should match(extension) }
      its(:exit_status) { should eq 0 }
    end
  end

  describe command(cmd_extension_exists("testdb", "fake_extension")) do
    its(:stdout) { should_not match("fake_extension") }
    its(:exit_status) { should eq 1 }
  end

  installed_languages = %w[
    plpgsql plperl plproxy plpythonu plpython3u plr pltcl plv8
  ]
  installed_languages.each do |language|
    describe command(cmd_language_exists("testdb", language)) do
      its(:stdout) { should match(language) }
      its(:exit_status) { should eq 0 }
    end
  end

  describe command(cmd_language_exists("testdb", "fake_language")) do
    its(:stdout) { should_not match("fake_language") }
    its(:exit_status) { should eq 1 }
  end
end
