require_relative "test_helper"

describe_recipe "postgresql::apt_repository" do
  let(:apt_source_list) { "/etc/apt/sources.list.d/apt.postgresql.org.list" }

  it "set up an apt repository for `apt.postgresql.org`" do
    file(apt_source_list).must_exist
    file(apt_source_list).must_include "apt.postgresql.org"
  end

  it "installed the `pgdg-keyring` package" do
    package("pgdg-keyring").must_be_installed
  end
end
