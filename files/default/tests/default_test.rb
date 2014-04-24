require_relative "test_helper"

describe_recipe "postgresql::default" do
  it "added an apt preference" do
    file("/etc/apt/preferences.d/pgdg.pref").must_exist
  end

  it "set up an apt repository" do
    file("/etc/apt/sources.list.d/apt.postgresql.org.list").must_exist
  end

  it "installed the `postgresql-common` package" do
    package("postgresql-common").must_be_installed
  end
end
