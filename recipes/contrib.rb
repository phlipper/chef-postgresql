#
# Cookbook Name:: postgresql
# Recipe:: contrib
#

include_recipe "postgresql"

package "postgresql-contrib-#{node["postgresql"]["version"]}"
