#
# Cookbook Name:: postgresql
# Recipe:: apt_repository
#

# use `apt.postgresql.org` for primary package installation support
apt_repository node["postgresql"]["apt_repository"] do
  uri          node["postgresql"]["apt_uri"]
  distribution "#{node["postgresql"]["apt_distribution"]}-pgdg"
  components   node["postgresql"]["apt_components"]
  key          node["postgresql"]["apt_key"]
  keyserver    node["postgresql"]["apt_keyserver"]
end

# automatically get repository key updates
package "pgdg-keyring"
