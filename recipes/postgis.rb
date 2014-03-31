#
# Cookbook Name:: postgresql
# Recipe:: postgis
#

include_recipe "postgresql"

pg_version = node["postgresql"]["version"]
postgis_version = node["postgis"]["version"]

package "postgresql-#{pg_version}-postgis-#{postgis_version}"
