#
# Cookbook Name:: postgresql
# Recipe:: debian_backports
#


# backports for initial support
apt_repository "debian-backports" do
  uri "http://backports.debian.org/debian-backports"
  distribution "#{node["lsb"]["codename"]}-backports"
  components ["main"]
  action :add
end

# backports support for debian
%w[libpq5 postgresql-common].each do |pkg|
  package pkg do
    options "-t #{node["lsb"]["codename"]}-backports"
  end
end
