#
# Cookbook Name:: postgresql
# Recipe:: client
#

require_recipe "postgresql"

package "postgresql-client-#{node["postgresql"]["version"]}"
