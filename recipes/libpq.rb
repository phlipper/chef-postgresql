#
# Cookbook Name:: postgresql
# Recipe:: libpq
#

include_recipe "postgresql"

package "libpq5"
package "libpq-dev"
