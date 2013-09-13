#
# Cookbook Name:: postgresql
# Recipe:: default
#


# pin default package preferences
apt_preference "pgdg.pref" do
  glob "*"
  pin "release o=apt.postgresql.org"
  pin_priority "500"
end

case node["platform"]
when "ubuntu"
  include_recipe "postgresql::apt_repository"
  package "postgresql-common"  # install common files
when "debian"
  include_recipe "postgresql::debian_backports"
  include_recipe "postgresql::apt_repository"
end
