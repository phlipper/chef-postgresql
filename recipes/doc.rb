#
# Cookbook Name:: postgresql
# Recipe:: doc
#

include_recipe "postgresql"

package "postgresql-doc-#{node["postgresql"]["version"]}"
