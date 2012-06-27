#
# Cookbook Name:: postgresql
# Recipe:: contrib
#

require_recipe "postgresql"

package "postgresql-contrib-#{node["postgresql"]["version"]}"
