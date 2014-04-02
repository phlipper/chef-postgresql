#
# Cookbook Name:: postgresql
# Recipe:: postgis
#

if platform?("debian")
  log "The `postgis` recipe is not available for Debian at this time" do
    level :warn
  end
  return
end

include_recipe "postgresql"

pg_version = node["postgresql"]["version"]
postgis_version = node["postgis"]["version"]

package "postgresql-#{pg_version}-postgis-#{postgis_version}"
