#
# Cookbook Name:: postgresql
# Recipe:: default
#


# pin default package preferences
cookbook_file "/etc/apt/preferences.d/pgdg.pref" do
  source "pgdg.pref"
end

case node["platform"]
when "ubuntu"
  include_recipe "postgresql::apt_repository"
  package "postgresql-common"  # install common files
when "debian"
  include_recipe "postgresql::debian_backports"
  include_recipe "postgresql::apt_repository"
end
