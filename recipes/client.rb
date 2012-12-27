#
# Cookbook Name:: postgresql
# Recipe:: client
#

include_recipe "postgresql"

package "postgresql-client-#{node["postgresql"]["version"]}"
