require "spec_helper"

describe "Default PostgreSQL server installation" do
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
