#
# Cookbook Name:: postgresql
# Recipe:: postgis
#

require_recipe "postgresql"

package "postgresql-#{node["postgresql"]["version"]}-postgis"
