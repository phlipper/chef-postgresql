#
# Cookbook Name:: postgresql
# Recipe:: dbg
#

require_recipe "postgresql"

package "postgresql-#{node["postgresql"]["version"]}-dbg"
