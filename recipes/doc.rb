#
# Cookbook Name:: postgresql
# Recipe:: doc
#

require_recipe "postgresql"

package "postgresql-doc-#{node["postgresql"]["version"]}"
