#
# Cookbook Name:: postgresql
# Recipe:: dbg
#

include_recipe "postgresql"

package "postgresql-#{node["postgresql"]["version"]}-dbg"
