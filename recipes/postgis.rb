#
# Cookbook Name:: postgresql
# Recipe:: postgis
#

include_recipe "postgresql"

package "postgresql-#{node["postgresql"]["version"]}-postgis-#{node["postgis"]["version"]}"
