#
# Cookbook Name:: postgresql
# Recipe:: server_dev
#

include_recipe "postgresql"

# don't auto-start the service to allow custom configuration
dpkg_autostart "postgresql" do
  allow false
end

# install the package
package "postgresql-server-dev-#{node["postgresql"]["version"]}"
