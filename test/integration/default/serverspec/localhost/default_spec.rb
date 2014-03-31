require "spec_helper"

describe "Default PostgreSQL system setup" do
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

  it "installs the `postgresql-common` package" do
    expect(package "postgresql-common").to be_installed
  end
end
