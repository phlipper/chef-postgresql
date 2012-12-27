#
# Cookbook Name:: postgresql
# Recipe:: default
#

case node["lsb"]["id"]
when "Ubuntu"

  apt_repository "pitti-postgresql" do
    uri "http://ppa.launchpad.net/pitti/postgresql/ubuntu"
    distribution node["lsb"]["codename"]
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "8683D8A2"
    action :add
    notifies :run, "execute[apt-get update]", :immediately
  end

  # install common files
  package "postgresql-common"

when "Debian"

  # backports for initial support
  apt_repository "debian-backports" do
    uri "http://backports.debian.org/debian-backports"
    distribution "#{node["lsb"]["codename"]}-backports"
    components ["main"]
    action :add
    notifies :run, "execute[apt-get update]", :immediately
  end

  cookbook_file "/etc/apt/preferences.d/pgdg.pref" do
    source "pgdg.pref"
  end

  # backports support for debian
  %w[libpq5 postgresql-common].each do |pkg|
    package pkg do
      options "-t #{node["lsb"]["codename"]}-backports"
    end
  end

  # use `apt.postgresql.org` for primary package installation support
  apt_repository "apt.postgresql.org" do
    uri "http://apt.postgresql.org/pub/repos/apt"
    distribution "#{node["lsb"]["codename"]}-pgdg"
    components ["main"]
    key "http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc"
    action :add
    notifies :run, "execute[apt-get update]", :immediately
  end
end
